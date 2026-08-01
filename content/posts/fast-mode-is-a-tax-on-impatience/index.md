---
title: "Fast Mode Is a Tax on Impatience"
date: 2026-08-01
author: "Krishnan Chandra"
draft: true
description: "On a fixed subscription like Cursor Pro, fast mode burns included usage without adding intelligence. How I maximize what $20 can do, and why fast toggles are the wrong default."
---

Every major AI coding product now sells a "fast mode." Claude has `/fast`. Codex has `/fast on`. Cursor passes through fast variants of third-party models and ships its own fast toggle on Composer 2.5. The pitch is always the same: pay more, wait less.

Whether that pitch is a good deal depends on who is paying.

**Employer-backed developers** often have effectively unlimited token spend. A 2x or 6x queue surcharge is noise against salary. Burn rate barely registers. The real question is whether you are blocked waiting on a model, and routing plus parallelism answer that without a speed toggle.

**Subscription payers** live in a different economy. Cursor Pro is $20 a month. That is not an abstract API line item. It is a fixed monthly bucket of included usage, with overage rates that hurt when you blow through it. Every token choice is a trade inside the same cap: one session on Composer Fast, or six comparable sessions on Composer Standard for the same model and work. Fast mode does not add intelligence. It drains the bucket.

This post is written for the second group. It is the story of how I learned to maximize the value of my $20 Cursor Pro subscription, and why fast mode turned out to be one of the worst places to spend inside that cap.

I think the pitch is a tax on impatience. For subscription payers it is also a tax on inattention, because the expensive tier is often on by default before you notice.

Not because fast mode is fake. The responses do arrive faster. The labs are unusually honest about what you are buying: same model, faster queue, higher per-token rate. The problem is what you buy with a scarce monthly pool. Most of the time, the better move is a cheaper throughput tier of the same model, a smaller model that answers the right question in one shot, or standard speed while you work on something else.

I drafted this post on Composer 2.5 Standard while running a second agent on another task. I never sat idle waiting for tokens. Not fast Opus. Not fast Sol. Not Composer Fast. That workflow is how I stretch the plan: parallel agents on Standard tiers, routed by task, with fast toggles off.

## What fast mode actually is

Fast mode is not a smarter model. It is the same weights on a faster inference queue.

Claude's docs describe it as "up to 2.5x higher output tokens per second" on Opus 5 and Opus 4.8, with "no change to intelligence or capabilities." OpenAI renamed Priority Processing to Fast Mode in July 2026 and made the same claim for GPT-5.6 Sol. Cursor's Composer 2.5 Fast and Standard are explicitly the same model with different throughput tiers.

You are not buying capability. You are buying queue priority at a higher per-token rate.

On a $20 plan, that surcharge applies to every token in the month. On a company tab, it is usually irrelevant. The section below is the subscription-payer math: how fast mode shrinks what you can do before the cap runs out. Routing and parallelism later matter for both audiences.

## Fast mode shrinks what your plan can do

On Cursor Pro, included usage is the whole game. Fast mode does not add capability. It spends your monthly allocation faster on the same work.

Inside each product, Standard is the default throughput tier. Fast mode is a premium queue on the same weights. Claude and Sol API fast charge 2x. Codex subscription fast charges 2.5x credits on the same model. Composer 2.5 Fast charges 6x on identical weights inside Cursor.

For a subscription payer, the question is not how fast tokens arrive. It is how many agent sessions fit in the month. A 6x multiplier means six sessions of comparable work on Standard, or one on Fast. A 2x multiplier means half the sessions. Fast mode trades breadth of what you can do for speed on a single run.

{{< vega id="tier-cost" file="price_latency.vl.json" >}}

Hover a bar for the full tier name. The dashed line is Standard (1x). Each fast bar shows how many times more of your included usage the same session consumes. Codex fast is priced in subscription credits, not API dollars, but the logic is identical: more credits per token, fewer runs left in the bucket.

**The rule I follow on my $20 plan: stay on Standard for everyday work, and maximize useful work per included token, not tokens per second.** I do not turn on fast unless something is genuinely break-glass.

## The cross-product math

Here is what the labs publish today. Sources: [Anthropic fast mode docs](https://platform.claude.com/docs/en/build-with-claude/fast-mode), [OpenAI fast mode guide](https://developers.openai.com/api/docs/guides/fast-mode), [Codex speed docs](https://developers.openai.com/codex/speed), and [Cursor's models and pricing page](https://cursor.com/docs/models-and-pricing).

| Product | Standard cost | Fast cost | Price multiplier | Advertised speed gain | Notes |
| --- | --- | --- | --- | --- | --- |
| Claude Opus 5 (API) | $5 / $25 per MTok | $10 / $50 per MTok | 2x | Up to 2.5x output tokens/sec | Input taxed at 2x with no stated speed benefit. Gain is OTPS, not time-to-first-token. |
| Codex / GPT-5.6 Sol (API) | $5 / $30 per MTok | $10 / $60 per MTok | 2x | Up to 2.5x | Same model, same intelligence. |
| Codex (subscription credits) | 1x credits | 2.5x credits on GPT-5.6 / 5.5 | 2.5x | 1.5x speed | 2.5x credits per token on the same model. |
| Cursor GPT-5.4 fast | $2.50 / $15 per MTok | 2x standard | 2x | 15% faster | Double the spend for the same tokens. |
| Cursor Composer 2.5 | $0.50 / $2.50 per MTok | $3.00 / $15.00 per MTok | 6x | Not published | Same model. Fast is the default. Toggle is hidden. |

Read the table as budget depletion, not a speed scorecard. Every multiplier applies to every token in a session. On a $20 pool, the same session costs six times as much on Composer Fast as on Standard for the same model and work. Codex subscription fast spends 2.5x the credits per token. API fast modes double the per-token rate on both input and output.

The speed column is what the labs advertise for output generation. It does not change the spend math. You pay the multiplier on the full session either way. The measurements are not uniform across rows: Anthropic cites OTPS, Cursor cites wall-clock for GPT-5.4 fast, and Composer does not publish a number. Compare burn rates, not speed claims, across products.

## The input-token tax

This is the part of the pricing that is closest to "paying for something you do not receive."

**Input gets billed at the fast rate with no speed benefit.** Agent sessions resend large context every turn: system prompts, file reads, conversation history. In a typical long agent run, input tokens dominate volume. You pay 2x on all of it for a speed gain that applies only to output generation.

**The speed gain is token generation, not end-to-end latency.** Anthropic is explicit that fast mode improves output tokens per second, not time to first token. For tool-calling agents, much of wall-clock time is tool execution, not streaming. A 2.5x OTPS gain on output generation does not translate to a 2.5x gain on the full run.

**Cache re-pricing is a trap.** In Claude Code, enabling fast mode mid-conversation re-prices your entire cached context at the fast rate from the first token. Fast mode also draws from usage credits immediately and does not count against plan-included usage. That is the mechanism behind "drain your usage faster," and it is buried in the billing docs, not the marketing. Unlike the headline 2x multiplier, this can push real spend above what the chart shows.

The chart above shows what you pay per token. This section shows how little of the advertised speed that payment buys in an agent loop: input taxed at 2x with no corresponding speed benefit, output speedups that do not compound across tool calls, and cache traps that can re-price history you already paid for.

## The empirical case and the structural case

There are two separate arguments against fast mode, and conflating them weakens both.

**Argument 1 (empirical): the current multiples are bad.** Codex subscription fast mode charges 2.5x credits for the same tokens. Cursor's GPT-5.4 fast doubles the price for a 15% speed bump. Composer Fast charges 6x on identical weights. These numbers could change tomorrow, and some of them are objectively poor deals today.

**Argument 2 (structural): queue priority is the wrong thing to buy with scarce budget.** Given a fixed credit pool or monthly cap, marginal tokens go furthest on smarter model routing and cheaper models for narrow jobs, not sooner tokens on the model you already picked. A proportional 2x-for-2x fast tier might be "fair" in isolation and still be the wrong purchase when Nano answers your diagnostic question for pennies and Standard Composer covers another six sessions in the same bucket.

I hold both. The first is about today's pricing. The second is about what you should optimize for regardless of how the labs price speed tomorrow.

## Composer 2.5 is the whole pattern in miniature

Cursor is the interesting case because they control the model and the product.

Composer 2.5 is a 1T-parameter mixture-of-experts model with 32B active parameters per token, built on Moonshot's Kimi K2.5 checkpoint and trained by Cursor for agentic coding. It is architecturally leaner than running a dense frontier model. On Standard, it is priced at roughly one-tenth the per-token cost of Opus for everyday coding work. Cursor markets that price, then defaults everyone onto Fast, which erases most of the advantage.

It is already fast. That is the point.

And yet Cursor ships two tiers of the same model:

| Tier | Input | Output | What you get |
| --- | --- | --- | --- |
| Standard | $0.50 / MTok | $2.50 / MTok | Same intelligence, lower throughput |
| Fast (default) | $3.00 / MTok | $15.00 / MTok | Same intelligence, higher throughput |

Six times the price. Zero difference in intelligence. Cursor's own docs say the fast variant has "the same intelligence." Cursor does not publish a speed multiplier for the Fast tier.

Worse, Fast is on by default. There is no separate "Composer 2.5 Standard" entry in the model picker. You hover over Composer 2.5, click the small Edit button, and toggle Fast off. Or use `Ctrl+Alt+/`. Forum threads are full of people who did not know Standard existed until their credits vanished. The labs tax impatience. Cursor goes further and charges the tax by default, so you pay it without ever having been impatient.

I drafted this post on Standard while reviewing another agent's output in parallel. Back-of-envelope token math for this session puts Standard around $0.10 and Fast around $0.60 for the same work. Same model. Six times the burn rate for tokens that arrived while I was already busy elsewhere.

Fast mode does not make the model smarter. It makes the invoice arrive sooner.

## Parallelism beats fast mode

If your employer pays, this is the section that still matters for you.

The attention-economics defense of fast mode goes like this: if you bill $200/hour, saving two minutes of wait time on a $0.50 premium is obviously worth it.

My answer is that I do not sit idle while a model runs. I parallelize. While one agent works, I prompt or review another. Generation latency stops being dead time because I am not waiting on a single serial pipeline. Fast mode and parallelism solve the same problem (time spent blocked on a model), and parallelism is free in dollars.

This is a learnable skill, not a universal workflow. Context-switching between agent sessions has real cost, and not everyone wants to run three agents at once. But for the way I work, fast mode has never beaten parallelism outside the break-glass case below, because I am rarely waiting in the first place.

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
| Overnight evals, migrations, bulk work | GPT-5.4 Nano or cheaper models at Standard speed |

The pattern is task-first routing, not "turn on fast mode and hope."

A targeted question to Nano answers in seconds at a fraction of the cost of fast Opus. Deep investigation belongs on a frontier model at standard speed, where you are paying for intelligence, not queue priority. Composer Standard covers most interactive coding without the 6x markup.

Latency sensitivity in a coding workflow is real. Nobody wants a 90-second wait for a two-line edit. The remedy is a smaller or faster-by-architecture model, not a priority queue on a big one.

Fast mode solves latency on the model you already picked. Model routing solves the harder problem of picking the right model in the first place. Routing and throughput tier are separate choices. My default is Standard on whatever model I routed to.

## Break glass, not default

Fast mode should not be your habitual answer to latency. It should be break-glass in case of emergency.

The narrow case where I would consider it: a serial, frontier-model agent run where wall-clock is the critical path, I have already done the routing and diagnosis, the prompt is final, and parallelism cannot help. A production incident where every minute of downtime has a real cost, and the fix genuinely requires a long run on the model I have already correctly chosen.

That happens rarely. Break-glass tools are supposed to be expensive per use. At break-glass frequency, even fast Opus at 2x API pricing costs pennies a year. The problem is not that the premium tier exists. The problem is that it is sold and defaulted as an everyday mode. Cursor wiring Fast as the hidden-toggle default is a fire extinguisher that discharges on every keystroke.

## What I changed on my $20 plan

These are the defaults I settled on after burning through included usage too fast on Composer Fast:

1. **Turn off fast toggles by default.** Claude `/fast` off. Codex `/fast off`. Composer Fast off via the hidden toggle.
2. **Stay on Standard throughput tiers.** Everyday interactive work on Standard, not Fast. Fast only for break-glass.
3. **Route by task, not by impatience.** Cheap models for narrow questions. Frontier models at standard speed for hard problems. Composer Standard for everyday agentic coding in Cursor.
4. **Parallelize instead of paying for speed.** Multiple agents, multiple models, fan-out on diagnostics. Do not sit idle waiting for one serial pipeline.
5. **Watch the billing traps.** Fast mode on Claude Code draws from usage credits from token one. Toggling mid-conversation re-prices your entire cached context at the fast rate.

## Coming next

This post is the economics and the pattern behind stretching a $20 plan. Before publish I will replace the back-of-envelope dollar figures here with dashboard numbers. The follow-up will walk through a real task end to end on Cursor Pro: which models I used at each step, what fast mode would have cost against my monthly bucket, and what I actually spent.

If you are on a fixed subscription and defaulting to fast mode because waiting feels bad, you are probably reaching for the wrong tool. The labs want you to pay more per token for the same model. You want the right model at Standard speed, so more of your monthly cap turns into finished work. Those are not the same thing. If your employer pays, the burn-rate argument may not bite, but the routing, parallelism, and break-glass defaults still apply.
