---
title: "Fast Mode Is a Scam"
date: 2026-08-01
author: "Krishnan Chandra"
draft: true
description: "Fast mode charges a premium for queue priority on the same model. Model routing beats paying for speed almost every time."
---

Every major AI coding product now sells a "fast mode." Claude has `/fast`. Codex has `/fast on`. Cursor passes through fast variants of third-party models and ships its own fast toggle on Composer 2.5. The pitch is always the same: pay more, wait less.

I think that pitch is a scam.

Not because fast mode is fake. The responses do arrive faster. The scam is that you are paying for the wrong thing. Fast mode makes a large model respond sooner. Most of the time, what you actually need is a smaller or cheaper model that answers the right question in one shot, or the same model at standard speed while you think.

I wrote this entire post on Composer 2.5 Standard. Not fast Opus. Not fast Sol. Not Composer Fast. It kept up fine.

## What fast mode actually is

Fast mode is not a smarter model. It is the same weights on a faster inference queue.

Claude's docs describe it as "up to 2.5x higher output tokens per second" on Opus 5 and Opus 4.8, with "no change to intelligence or capabilities." OpenAI renamed Priority Processing to Fast Mode in July 2026 and made the same claim for GPT-5.6 Sol. Cursor's Composer 2.5 Fast and Standard are explicitly the same model with different throughput tiers.

You are not buying capability. You are buying queue priority.

That would be fine if the price tracked the speed gain. It usually does not.

## The cross-product math

Here is what the labs publish today. I pulled these numbers from [Anthropic's fast mode docs](https://platform.claude.com/docs/en/build-with-claude/fast-mode), [OpenAI's fast mode guide](https://developers.openai.com/api/docs/guides/fast-mode), [Codex speed docs](https://developers.openai.com/codex/speed), and [Cursor's models and pricing page](https://cursor.com/docs/models-and-pricing).

| Product | Standard cost | Fast cost | Price multiplier | Advertised speed gain | Notes |
| --- | --- | --- | --- | --- | --- |
| Claude Opus 5 (API) | $5 / $25 per MTok | $10 / $50 per MTok | 2x | Up to 2.5x output tokens/sec | Input taxed at 2x with no stated speed benefit. Gain is OTPS, not time-to-first-token. |
| Codex / GPT-5.6 Sol (API) | $5 / $30 per MTok | $10 / $60 per MTok | 2x | Up to 2.5x | Same model, same intelligence. |
| Codex (subscription credits) | 1x credits | 2.5x credits (5.6 / 5.5) | 2.5x | 1.5x speed | Worst ratio in the table. You pay 67% more per unit of speed. |
| Cursor GPT-5.4 fast | $2.50 / $15 per MTok | 2x standard | 2x | 15% faster | Absurd on its face. |
| Cursor Composer 2.5 | $0.50 / $2.50 per MTok | $3.00 / $15.00 per MTok | 6x | ~1.5x wall-clock (third-party benchmarks) | Same model. Fast is the default. Toggle is hidden. |

On paper, the API products look almost fair. Pay 2x, get up to 2.5x output throughput. That breaks down quickly once you look at how agentic work actually runs.

**Input gets taxed at the fast rate with no speed benefit.** Agent sessions resend large context every turn. System prompts, file reads, conversation history. Fast mode pricing hits all of it.

**The speed gain is token generation, not end-to-end latency.** Anthropic is explicit that fast mode improves output tokens per second, not time to first token. For tool-calling agents, most wall-clock time is tool execution, not streaming.

**Subscription fast mode is worse than API fast mode.** Codex charges 2.5x credits for 1.5x speed. That is not a premium tier. It is a tax on impatience.

## Composer 2.5 is the whole scam in miniature

Cursor is the interesting case because they control the model and the product.

Composer 2.5 is a 1T-parameter mixture-of-experts model with 32B active parameters per token, built on Moonshot's Kimi K2.5 checkpoint and trained by Cursor for agentic coding. It is architecturally leaner than running a dense frontier model and priced at roughly one-tenth the per-token cost of Opus or GPT-5.5 on benchmarks that are within a point or two of those models for everyday coding work.

It is already fast. That is the point.

And yet Cursor ships two tiers of the same model:

| Tier | Input | Output | What you get |
| --- | --- | --- | --- |
| Standard | $0.50 / MTok | $2.50 / MTok | Same intelligence, lower throughput |
| Fast (default) | $3.00 / MTok | $15.00 / MTok | Same intelligence, higher throughput |

Six times the price. Zero difference in intelligence. Cursor's own docs say the fast variant has "the same intelligence."

Third-party benchmarks put the wall-clock speedup at roughly 1.5x. You pay 6x for 1.5x. That is a worse deal than Claude or Codex fast mode, and those were already questionable.

Worse, Fast is on by default. There is no separate "Composer 2.5 Standard" entry in the model picker. You hover over Composer 2.5, click the small Edit button, and toggle Fast off. Or use `Ctrl+Alt+/`. Forum threads are full of people who did not know Standard existed until their credits vanished.

I drafted this post on Standard. Research, ideation, back-and-forth editing. It never felt slow. For a session like this, rough token math puts Standard at about $0.10 and Fast at about $0.62 for the same work. Same model. Six times the cost for tokens that arrive slightly sooner while I was thinking anyway.

<!-- TODO: Replace rough estimate with actual usage numbers from dashboard after publish -->

Fast mode does not make the model smarter. It makes the invoice arrive sooner.

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

The pattern is task-first routing, not "turn on fast mode and hope."

A targeted question to Nano or Haiku answers in seconds at a fraction of the cost of fast Opus. Deep investigation belongs on a frontier model at standard speed, where you are paying for intelligence, not queue priority. Composer Standard covers most interactive coding without the 6x markup.

Fast mode solves latency on the model you already picked. Model routing solves the harder problem of picking the right model in the first place.

## When fast mode might be worth it

I will be honest about the narrow case.

Fast mode might make sense when you have already done the thinking, the prompt is final, and you are paying for throughput on a known-good generation. A production incident where every second of human wait time has a real cost. Maybe.

Even then, a smaller model that answers in one shot often beats a fast large model that overthinks. I have not found a workflow where fast mode was the right lever often enough to justify defaulting it on. Your mileage may vary, but mine has been: almost never.

## What I am doing instead

1. **Turn off fast toggles.** Claude `/fast` off unless I have a specific reason. Codex `/fast off`. Composer Fast off via the hidden toggle.
2. **Route by task, not by impatience.** Cheap models for narrow questions. Frontier models at standard speed for hard problems. Composer Standard for everyday agentic coding in Cursor.
3. **Watch the billing mechanism.** Claude Code fast mode draws from usage credits from token one and does not count against plan-included usage. Enabling it mid-conversation re-prices your entire cached context at the fast rate. That is the "drain your usage faster" mechanism made concrete.

## Coming next

This post is the economics and the pattern. The follow-up will walk through a real task end to end: which models I used at each step, what fast mode would have cost, and what I actually spent.

If you are defaulting to fast mode because waiting feels bad, you are probably reaching for the wrong tool. The labs want you to pay for speed. You want the right model at the right step. Those are not the same thing.
