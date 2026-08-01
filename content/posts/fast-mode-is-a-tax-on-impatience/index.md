---
title: "Fast Mode Is a Tax on Impatience"
date: 2026-08-01
author: "Krishnan Chandra"
draft: true
description: "Fast mode is a disclosed premium for queue priority on the same model. Route down the price-latency curve instead of paying for speed."
---

Every major AI coding product now sells a "fast mode." Claude has `/fast`. Codex has `/fast on`. Cursor passes through fast variants of third-party models and ships its own fast toggle on Composer 2.5. The pitch is always the same: pay more, wait less.

I think that pitch is a tax on impatience.

Not because fast mode is fake. The responses do arrive faster. The labs are unusually honest about what you are buying: same model, faster queue, higher per-token rate. The problem is that you are paying for the wrong thing. Fast mode makes a large model respond sooner. Most of the time, what you actually need is a smaller or cheaper model that answers the right question in one shot, or the same model at standard speed while you work on something else.

I wrote this entire post on Composer 2.5 Standard. Not fast Opus. Not fast Sol. Not Composer Fast. It kept up fine.

## What fast mode actually is

Fast mode is not a smarter model. It is the same weights on a faster inference queue.

Claude's docs describe it as "up to 2.5x higher output tokens per second" on Opus 5 and Opus 4.8, with "no change to intelligence or capabilities." OpenAI renamed Priority Processing to Fast Mode in July 2026 and made the same claim for GPT-5.6 Sol. Cursor's Composer 2.5 Fast and Standard are explicitly the same model with different throughput tiers.

You are not buying capability. You are buying queue priority.

That would be fine if the price tracked the speed gain, and if speed were the bottleneck in your workflow. Usually neither is true.

## The price-latency curve

Latency and cost are not a single knob. They are a spectrum, and the labs sell both directions.

On the cheap, slow end, OpenAI's [Batch API and Flex tier](https://developers.openai.com/api/docs/pricing) cut standard token rates by 50%. Anthropic's [batch processing](https://platform.claude.com/docs/en/about-claude/pricing) does the same. Batch is async (up to 24 hours). Flex is synchronous but best-effort, and may queue during peak demand. Both are for work that does not need a human staring at the screen.

In the middle sits Standard: the default synchronous tier.

Above Standard sits Fast mode: 2x API pricing for Claude and Sol, 2.5x Codex subscription credits for 1.5x speed, 6x for Composer 2.5 Fast on the same model weights.

The pattern is asymmetric. Going *down* the curve buys you 50% off for latency you often do not need. Going *up* charges a premium that grows faster than the speed gain, especially once you account for how agentic work actually runs.

{{< vega id="price-latency" file="price_latency.vl.json" >}}

Hover a point for tier details. The dashed line is fair value, where a price multiplier buys the same speed multiplier. Points above the line cost more than the speed is worth. Points below it are bargains you should be using more. Fast mode clusters above the line. Batch and Flex cluster below it.

**The rule I follow: route down the price-latency curve, not up.** Bulk work (eval runs, migrations, overnight refactors, doc generation) goes to Batch or Flex at half price. Interactive work stays on Standard. I do not live above Standard unless something is genuinely break-glass.

## The cross-product math

Here is what the labs publish today. Sources: [Anthropic fast mode docs](https://platform.claude.com/docs/en/build-with-claude/fast-mode), [OpenAI fast mode guide](https://developers.openai.com/api/docs/guides/fast-mode), [Codex speed docs](https://developers.openai.com/codex/speed), and [Cursor's models and pricing page](https://cursor.com/docs/models-and-pricing).

| Product | Standard cost | Fast cost | Price multiplier | Advertised speed gain | Notes |
| --- | --- | --- | --- | --- | --- |
| Claude Opus 5 (API) | $5 / $25 per MTok | $10 / $50 per MTok | 2x | Up to 2.5x output tokens/sec | Input taxed at 2x with no stated speed benefit. Gain is OTPS, not time-to-first-token. |
| Codex / GPT-5.6 Sol (API) | $5 / $30 per MTok | $10 / $60 per MTok | 2x | Up to 2.5x | Same model, same intelligence. |
| Codex (subscription credits) | 1x credits | 2.5x credits (5.6 / 5.5) | 2.5x | 1.5x speed | Worst ratio in the table. |
| Cursor GPT-5.4 fast | $2.50 / $15 per MTok | 2x standard | 2x | 15% faster | 2x price for a 15% speed bump. |
| Cursor Composer 2.5 | $0.50 / $2.50 per MTok | $3.00 / $15.00 per MTok | 6x | Not published | Same model. Fast is the default. Toggle is hidden. |

Even at the labs' own best-case speed claims, the math is shaky for agentic work. Pay 2x, get up to 2.5x output throughput on a portion of the job. That breaks down once you look at what agent sessions actually spend money on.

## The input-token tax

This is the part of the pricing that is closest to "paying for something you do not receive."

**Input gets billed at the fast rate with no speed benefit.** Agent sessions resend large context every turn: system prompts, file reads, conversation history. In a typical long agent run, input tokens dominate volume. You pay 2x on all of it for a speed gain that applies only to output generation.

**The speed gain is token generation, not end-to-end latency.** Anthropic is explicit that fast mode improves output tokens per second, not time to first token. For tool-calling agents, much of wall-clock time is tool execution, not streaming. A 2.5x OTPS gain on 40% of the run is not a 2.5x gain on the run.

**Cache re-pricing is a trap.** In Claude Code, enabling fast mode mid-conversation re-prices your entire cached context at the fast rate from the first token. Fast mode also draws from usage credits immediately and does not count against plan-included usage. That is the mechanism behind "drain your usage faster," and it is buried in the billing docs, not the marketing.

On the chart above, the gap between "advertised OTPS" and "effective agentic speed" is mostly this input tax plus tool overhead. Even generous assumptions about generation speed leave fast mode above the fair-value line.

## Two objections, two answers

There are two separate arguments against fast mode, and conflating them weakens both.

**Argument 1 (empirical): the current multiples are bad.** Codex subscription fast mode charges 2.5x for 1.5x speed. Cursor's GPT-5.4 fast charges 2x for 15% faster. Composer Fast charges 6x on identical weights. These numbers could change tomorrow, and some of them are objectively poor deals today.

**Argument 2 (structural): even at fair multiples, speed is the last thing to buy.** Given a fixed credit pool or monthly budget, marginal dollars go furthest on more tokens or smarter routing, not sooner tokens. A proportional 2x-for-2x fast tier might be "fair" in isolation and still be the wrong purchase when Nano answers your diagnostic question for pennies and Flex runs your eval suite at half price.

I hold both. The first is about today's pricing. The second is about what you should optimize for regardless of how the labs price speed tomorrow.

## Composer 2.5 is the whole pattern in miniature

Cursor is the interesting case because they control the model and the product.

Composer 2.5 is a 1T-parameter mixture-of-experts model with 32B active parameters per token, built on Moonshot's Kimi K2.5 checkpoint and trained by Cursor for agentic coding. It is architecturally leaner than running a dense frontier model and priced at roughly one-tenth the per-token cost of Opus or GPT-5.5 for everyday coding work.

It is already fast. That is the point.

And yet Cursor ships two tiers of the same model:

| Tier | Input | Output | What you get |
| --- | --- | --- | --- |
| Standard | $0.50 / MTok | $2.50 / MTok | Same intelligence, lower throughput |
| Fast (default) | $3.00 / MTok | $15.00 / MTok | Same intelligence, higher throughput |

Six times the price. Zero difference in intelligence. Cursor's own docs say the fast variant has "the same intelligence." Cursor does not publish a speed multiplier for the Fast tier. Even if you grant the most generous industry claim (2.5x output throughput, the same number Anthropic and OpenAI advertise for their own fast modes), you are paying 6x for 2.5x. That is the worst point on the chart.

Worse, Fast is on by default. There is no separate "Composer 2.5 Standard" entry in the model picker. You hover over Composer 2.5, click the small Edit button, and toggle Fast off. Or use `Ctrl+Alt+/`. Forum threads are full of people who did not know Standard existed until their credits vanished.

I drafted this post on Standard. Research, ideation, back-and-forth editing. It never felt slow. For a session like this, rough token math puts Standard at about $0.10 and Fast at about $0.62 for the same work. Same model. Six times the cost for tokens that arrive slightly sooner while I was thinking anyway.

Fast mode does not make the model smarter. It makes the invoice arrive sooner.

## Parallelism beats fast mode

The attention-economics defense of fast mode goes like this: if you bill $200/hour, saving two minutes of wait time on a $0.50 premium is obviously worth it.

My answer is that I do not sit idle while a model runs. I parallelize. While one agent works, I prompt or review another. Generation latency stops being dead time because I am not waiting on a single serial pipeline. Fast mode and parallelism solve the same problem (time spent blocked on a model), and parallelism is free.

This is a learnable skill, not a universal workflow. Context-switching between agent sessions has real cost, and not everyone wants to run three agents at once. But for the way I work, there is no wait-time savings at which fast mode pencils out, because I am rarely waiting in the first place.

The same logic applies to incidents. I do not reach for fast Opus first. I reach for Composer 2.5 or GPT-5.4 Nano to diagnose quickly and cheaply. If the bug needs a frontier model, I escalate then, or fan out small and large models on the same diagnostic question in parallel and take whichever answers well first. Fast mode is not step one. It is not step two. It is break-glass.

## The right tool is usually not "fast"

My workflows today use a mix of models, not a single frontier model with a speed surcharge:

| Job | Model |
| --- | --- |
| Planning and judgment | Fable 5 |
| Precise execution of a written spec | GPT-5.6 Sol |
| Fast iteration on code inside Cursor | Composer 2.5 Standard |
| Cheap bulk or targeted questions | GPT-5.4 Nano |
| Generalist fallback | Kimi K3 |
| Multimodal (image / video) | Gemini 3.6 Flash |
| Second opinions and adversarial review | Grok 4.5, GLM-5.2 |
| Overnight evals, migrations, batch work | Flex or Batch tiers |

The pattern is task-first routing, not "turn on fast mode and hope."

A targeted question to Nano answers in seconds at a fraction of the cost of fast Opus. Deep investigation belongs on a frontier model at standard speed, where you are paying for intelligence, not queue priority. Composer Standard covers most interactive coding without the 6x markup.

Latency sensitivity in a coding workflow is real. Nobody wants a 90-second wait for a two-line edit. The remedy is a smaller or faster-by-architecture model, not a priority queue on a big one.

Fast mode solves latency on the model you already picked. Model routing solves the harder problem of picking the right model in the first place.

## Break glass, not default

Fast mode should not be your habitual answer to latency. It should be break-glass in case of emergency.

The narrow case where I would consider it: a serial, frontier-model agent run where wall-clock is the critical path, I have already done the routing and diagnosis, the prompt is final, and parallelism cannot help. A production incident where every minute of downtime has a real cost, and the fix genuinely requires a long run on the model I have already correctly chosen.

That happens rarely. Break-glass tools are supposed to be expensive per use. At break-glass frequency, even Cursor's 6x Composer multiplier costs pennies a year. The problem is not that the premium tier exists. The problem is that it is sold and defaulted as an everyday mode. Cursor wiring Fast as the hidden-toggle default is a fire extinguisher that discharges on every keystroke.

## What I am doing instead

1. **Turn off fast toggles by default.** Claude `/fast` off. Codex `/fast off`. Composer Fast off via the hidden toggle.
2. **Route down the curve.** Batch and Flex for bulk work at 50% off. Standard for interactive work. Nothing above Standard unless break-glass.
3. **Route by task, not by impatience.** Cheap models for narrow questions. Frontier models at standard speed for hard problems. Composer Standard for everyday agentic coding in Cursor.
4. **Parallelize instead of paying for speed.** Multiple agents, multiple models, fan-out on diagnostics. Do not sit idle waiting for one serial pipeline.
5. **Watch the billing traps.** Fast mode on Claude Code draws from usage credits from token one. Toggling mid-conversation re-prices your entire cached context at the fast rate.

## Coming next

This post is the economics and the pattern. The follow-up will walk through a real task end to end: which models I used at each step, what fast mode would have cost, and what I actually spent.

If you are defaulting to fast mode because waiting feels bad, you are probably reaching for the wrong tool. The labs want you to pay for speed. You want the right model at the right step, on the right tier of the price-latency curve. Those are not the same thing.
