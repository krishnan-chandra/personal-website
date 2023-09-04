---
title: "Debugging Catastrophic Backtracking for Regular Expressions in Python"
date: 2023-09-03
author: "Krishnan Chandra"
draft: false
---

# Debugging Catastrophic Backtracking in Python

Recently, I was debugging a Python application that had become stuck while processing certain inputs. The process was taking up 100% CPU time but not making progress. To understand where the application was stuck, I turned to a handy profiling tool called [py-spy](https://github.com/benfred/py-spy).

## Using py-spy to Find the Bottleneck

py-spy is a sampling profiler for Python that lets you see where your code is spending time without modifying it. I used the `py-spy dump` command to attach to the stuck Python process and print out a snapshot of the current call stack across all threads.

You can use py-spy on a specific process ID by running

```shell
py-spy dump --pid <pid>
```

The result came back and look like this:

```shell
  %Own   %Total  OwnTime  TotalTime  Function (filename)
100.00% 100.00%   18.00s    18.00s   search (re.py)
  0.00% 100.00%   0.000s    18.00s   process_item (pipelines/summarization.py)
  0.00% 100.00%   0.000s    18.00s   execute (scrapy/cmdline.py)
  0.00% 100.00%   0.000s    18.00s   <module> (pex)
  0.00% 100.00%   0.000s    18.00s   _run_command (scrapy/cmdline.py)
  0.00% 100.00%   0.000s    18.00s   run_module (runpy.py)
  0.00% 100.00%   0.000s    18.00s   <module> (scrapy/__main__.py)
  0.00% 100.00%   0.000s    18.00s   _run_code (runpy.py)
  0.00% 100.00%   0.000s    18.00s   run (scrapy/commands/crawl.py)
  0.00% 100.00%   0.000s    18.00s   get_quotes_summary (ml/summarization.py)
  0.00% 100.00%   0.000s    18.00s   _run_module_code (runpy.py)
  0.00% 100.00%   0.000s    18.00s   run (twisted/internet/asyncioreactor.py)
  0.00% 100.00%   0.000s    18.00s   start (scrapy/crawler.py)
  0.00% 100.00%   0.000s    18.00s   _run_print_help (scrapy/cmdline.py)
  0.00
```

This application is a [Scrapy](https://scrapy.org/) spider, which explains why Scrapy and Twisted show up in the stack trace.

This immediately showed that the search function from Python's `re` regex module was taking up 100% of the process time.

# Catastrophic Backtracking in Regular Expressions

Now that I knew the culprit was a regex and where it was being called, I looked at the code:

```python
pattern = r'<summary>((\n*.*\n*)*)</summary>'
match = re.search(pattern, content.strip(), re.DOTALL)
```

This regex tries to match text within `<summary>` tags, while also explicitly matching newlines before and after each block of text. It defines capture groups for the whole content of the summary tags, as well as each newline-delimited

So what's the problem here?

As it turns out, the problem is twofold:

1. By default, regular expressions are matched greedily. If we look at the [Python documentation](https://docs.python.org/3/library/re.html#regular-expression-syntax), we see:

    > `*?`, `+?`, `??`
    >
    > The `'*'`, `'+'`, and `'?'` quantifiers are all greedy; they match as much text as possible. Sometimes this behaviour isn’t desired; if the RE `<.*>` is matched against `<a> b <c>`, it will match the entire string, and not just `<a>`. Adding ? after the quantifier makes it perform the match in non-greedy or minimal fashion; as few characters as possible will be matched. Using the RE `<.*?>` will match only `<a>`.

    The problem is the `((\n*.*\n*)*)` part - by repeating a newline-sandwiched pattern greedily, it leads to exponential runtime on strings with many newlines, as the engine tries every possible way to match newlines.

    This is known as catastrophic backtracking. The regex engine matches as far as it can initially with a greedy subpattern, then backtracks trying every possible matching combination before failing.

2. We were passing the [`re.DOTALL`](https://docs.python.org/3/library/re.html#re.DOTALL) flag when evaluating the regex. This flag makes the `.` character in regex match newlines. This further exacerbated the problem by including newlines surrounded by newlines as part of the match criteria!

## Fixing with a Non-Greedy Pattern

What we really want here is just to match all the text inside `<summary>` tags in a non-greedy fashion - if there are multiple tags, their contents should match separately.

To avoid catastrophic backtracking, the key is to make the repeating subpattern **non-greedy**, by adding the character `?` to the end as shown above in the documentation. Additionally, since we want to match newlines we retain the `re.DOTALL` flag.

```python
pattern_str = r"<summary>(.*?)</summary>"
pattern = re.compile(pattern_str, re.DOTALL)
match = re.search(pattern, content.strip())
```

Now, we get the smallest possible set of characters that are in between `<summary>` tags. This avoids getting stuck trying to match newlines exhaustively, and is also much easier to read!

Making the repeat non-greedy prevents the combinatorial explosion and makes the runtime linear rather than exponential in the worst case.

Additionally, we use the [re.compile](https://docs.python.org/3/library/re.html#re.compile) method to create an object that can be reused many times in the same program more efficiently. This call also lets us pass in the `re.DOTALL` flag once when the regex is created rather than on every invocation.


# Resources

* [Another similar article from Ben Frederickson](https://www.benfrederickson.com/python-catastrophic-regular-expressions-and-the-gil/)
* [An interesting paper on detecting catastrophic backtracking statically in Java](https://arxiv.org/abs/1405.5599)
