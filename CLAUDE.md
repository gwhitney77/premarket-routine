# Pre-Market Intelligence System — Routine Definition

## Purpose

Run every weekday at 8:30 AM US/Eastern. Sweep 10 live market indicators,
synthesise a daily trading strategy, generate 6 trade recommendations, and
deliver a formatted HTML report via email or Slack.

This file is the complete, self-contained instruction set for the Claude Code
Routine agent. Read all referenced support files before beginning execution.
Execute all 8 steps in strict order. Never ask for human input — this pipeline
runs fully unattended.

---

## Execution Steps — Follow in Strict Order

### Step 1 — Confirm Market Day

1. Read today's date from the system clock.
2. If today is **Saturday** (weekday index 6) or **Sunday** (weekday index 0):
   - Output: `Non-trading day — skipping run.`
   - Stop immediately. Do not proceed to any further steps.
3. Read `config.json`. Find the `skip_dates` array.
4. If today's date (format `YYYY-MM-DD`) appears in `skip_dates`:
   - Output: `Skipped date — skipping run.`
   - Stop immediately. Do not proceed to any further steps.
5. Success criteria: you have confirmed today is a weekday not in the skip list.
   Proceed to Step 2.

---

### Step 2 — Fetch All 10 Indicators

Read `indicators.md` for the full indicator list, search queries, and signal
thresholds before running any searches.

For **each** of the 10 indicators, in order 01–10:

1. Execute the exact web search query specified in `indicators.md` for that
   indicator.
2. From the search results, extract:
   - **name**: the display name from `indicators.md`
   - **value**: the current numeric reading or status, formatted appropriately
   - **context**: one sentence describing what this reading means right now
   - **signal**: exactly one of `bullish` / `bearish` / `caution` / `neutral`,
     determined by applying the threshold rules in `indicators.md`
   - **detail**: 2–3 sentences of additional context (trend, recent change,
     implication for today's session)
3. If a search returns no usable data:
   - Set `value` = `"unavailable — web search returned no data"`
   - Set `signal` = `"neutral"`
   - Set `context` = `"Data unavailable for this session."`
   - Set `detail` = `"Unable to retrieve live data. Signal defaulted to neutral. Check source manually."`
4. **Never skip an indicator.** All 10 must be recorded before proceeding.
5. Keep a running count of indicators successfully retrieved (vs. unavailable).

Error fallback: if a search errors or times out, treat it as "no usable data"
per rule 3 above and continue to the next indicator.

Success criteria: all 10 indicators have a recorded name, value, context,
signal, and detail. Proceed to Step 3.

---

### Step 3 — Score Overall Market Bias

1. Count the signals from Step 2:
   - `bull_count` = number of indicators with signal `bullish`
   - `bear_count` = number of indicators with signal `bearish`
   - `caution_count` = number of indicators with signal `caution`
   - `neutral_count` = number of indicators with signal `neutral`

2. Determine the primary bias string using this exact decision table:

   | Condition              | Bias string              |
   |------------------------|--------------------------|
   | 7–10 bullish signals   | `STRONGLY BULLISH`       |
   | 5–6 bullish signals    | `MODERATELY BULLISH`     |
   | 5–6 bearish signals    | `MODERATELY BEARISH`     |
   | 7–10 bearish signals   | `STRONGLY BEARISH`       |
   | Any other combination  | `MIXED / NEUTRAL`        |

3. After determining the primary bias, check caution_count:
   - If `caution_count >= 3`, append `— HIGH VOLATILITY EXPECTED` to the bias
     string regardless of what the primary bias is.
   - Example: `MODERATELY BULLISH — HIGH VOLATILITY EXPECTED`

4. Determine `bias_color` using this rule:
   - Bias contains "BULLISH" → `#16a359`
   - Bias contains "BEARISH" → `#e84040`
   - Bias contains "HIGH VOLATILITY" (without clear bull/bear) → `#d4a010`
   - Otherwise (MIXED / NEUTRAL) → `#5a7da8`

5. Record: `bias`, `bias_color`, `bull_count`, `bear_count`, `caution_count`.

Success criteria: bias string, bias_color, and three counts are determined.
Proceed to Step 4.

---

### Step 4 — Synthesise Daily Strategy

1. Read `strategy_template.md` fully before writing.
2. Using all 10 indicator readings from Step 2 and the bias from Step 3, write
   a complete trading strategy briefing.
3. The strategy **must** contain all 6 sections defined in
   `strategy_template.md`, in the order specified there.
4. Follow all HTML formatting rules in `strategy_template.md` exactly:
   - Use `<h3>` for section headers
   - Use `<ul><li>` for bullet lists
   - Wrap the overall bias sentence in `<div class="highlight">`
   - Use `<span class="bull">`, `<span class="bear">`, `<span class="caution">`
     for coloured text
   - No markdown — HTML only
   - Maximum 600 words total across all 6 sections
5. Store the complete strategy HTML as `strategy_html`.

Error fallback: if the strategy is incomplete, include what was generated,
note any missing sections as `<p class="error">[Section unavailable]</p>`,
and continue. Do not abort the pipeline.

Success criteria: `strategy_html` contains all 6 section headers and is valid
HTML. Proceed to Step 5.

---

### Step 5 — Generate Trade Recommendations

1. Read `trades_template.md` fully before generating any trade cards.
2. Using the live market conditions from Steps 2–3, generate exactly **6**
   trade recommendations.
3. Trade mix rules:
   - 2–3 LONG trades in the strongest sectors identified in Step 2
   - 1–2 SHORT or bearish plays on the weakest sectors identified in Step 2
   - 1 HEDGE or volatility play (e.g. VIX-related ETF, put spread setup,
     or inverse ETF)
   - For earnings-driven LONG trades, only include a ticker if it beat
     **both** EPS and revenue consensus estimates — a single-metric beat
     does not qualify.
4. **Post-earnings gap check:** For any ticker with a pre-market move of
   >5% in either direction, assess whether the trade is *with* the gap
   (momentum) or *against* the gap (counter-trend fade):
   - **With-gap trade** (e.g. long a stock up 7% on an earnings beat):
     standard process applies.
   - **Against-gap trade** (e.g. short a stock already down 8% overnight):
     require a conditional entry trigger. Populate `entry_condition` (field
     12 in `trades_template.md`) with the specific trigger — for example:
     *"Enter short only if stock fails to reclaim VWAP within first 30
     minutes."* Set conviction one notch lower than the raw signal warrants.
5. For each trade, populate all 11 mandatory fields defined in
   `trades_template.md`:
   `ticker`, `name`, `direction`, `thesis`, `entry`, `stop`, `target`,
   `rr`, `conviction`, `timing`, `catalyst`
   When a trade has a conditional entry trigger (per rule 4), also populate
   the optional `entry_condition` field (field 12) from `trades_template.md`.
6. Before generating any trade card, run a dedicated web search for each
   ticker's current price. Use the exact query format:
   `{TICKER} stock price premarket today {YYYY-MM-DD}`
   Extract the most recent premarket or last-close price from the results.
   If a search returns no usable price, note it and use the best available
   estimate from the indicator data in Step 2 — mark that card's entry price
   with `(est.)` to indicate it was not directly verified.
7. Requirements:
   - Use real, actively traded tickers (stocks or ETFs)
   - Base entry, stop, and target on the prices retrieved in rule 6 above —
     never estimate from index-level data alone
   - For post-earnings gap plays, set the stop-loss below the **gap fill
     level** (the stock's opening print at market open), not just below the
     entry price — intraday gap fills are common and a stop placed above the
     open will be hit before any trend resumes.
   - For intraday sector ETF longs on days with a high-impact macro release
     at market open (CPI, PCE, NFP, GDP, FOMC), use a dynamic entry: enter
     on the **first 5-minute bar close above the pre-market high** rather
     than a static price limit, to avoid missing fast gap-and-go moves.
   - Format all prices as `$XXX.XX`
   - Calculate R:R as `(target − entry) / (entry − stop)` for longs,
     `(entry − target) / (stop − entry)` for shorts
   - Format R:R as `1:X.X`
8. Render each trade as an HTML card following the exact structure and inline
   CSS rules in `trades_template.md`.
9. Concatenate all 6 trade cards into `trades_html`.

Error fallback: if fewer than 6 trades can be generated, generate as many as
possible, insert `<div class="trade-card-placeholder">[Trade unavailable]</div>`
for missing slots, and note the gap in the log.

Success criteria: `trades_html` contains exactly 6 trade cards (or placeholders
where generation failed). Proceed to Step 6.

---

### Step 6 — Assemble the HTML Report

1. Read `report_template.html` fully.
2. Determine the count of LONG, SHORT, and HEDGE trades from the 6 cards
   generated in Step 5.
3. Replace every `{{placeholder}}` token in the template with real values:

   | Token            | Replace with                                         |
   |------------------|------------------------------------------------------|
   | `{{DATE}}`       | Today's date, e.g. `Wednesday, April 30, 2026`       |
   | `{{TIME}}`       | Current time ET, e.g. `8:34 AM ET`                  |
   | `{{BIAS}}`       | Full bias string from Step 3                         |
   | `{{BIAS_COLOR}}` | Hex color from Step 3                                |
   | `{{BULL_COUNT}}` | `bull_count` from Step 3                             |
   | `{{BEAR_COUNT}}` | `bear_count` from Step 3                             |
   | `{{CAUTION_COUNT}}` | `caution_count` from Step 3                       |
   | `{{LONG_COUNT}}` | Number of LONG trades                                |
   | `{{SHORT_COUNT}}`| Number of SHORT trades                               |
   | `{{HEDGE_COUNT}}`| Number of HEDGE trades                               |
   | `{{INDICATORS}}` | All 10 indicator cards rendered as HTML (see below)  |
   | `{{STRATEGY}}`   | `strategy_html` from Step 4                          |
   | `{{TRADES}}`     | `trades_html` from Step 5                            |

4. Render each indicator as an HTML card containing:
   - Two-digit number (01–10), display name
   - Current value
   - Signal badge with appropriate colour:
     - `bullish` → `#16a359`
     - `bearish` → `#e84040`
     - `caution` → `#d4a010`
     - `neutral` → `#5a7da8`
   - Context sentence
   All using inline CSS consistent with the dark theme (`background: #0d1220`,
   `border: 1px solid #1e3a5f`, `color: #e8f0fe`).
   Concatenate all 10 into the `{{INDICATORS}}` replacement string.

5. Verify no `{{placeholder}}` tokens remain in the assembled HTML.
6. Save the completed HTML to a file named `report_YYYY-MM-DD.html`
   (where YYYY-MM-DD is today's date).

Error fallback: if any placeholder replacement fails, insert
`[DATA UNAVAILABLE]` and continue assembly. Log the failed token.

Success criteria: `report_YYYY-MM-DD.html` exists, contains no unreplaced
`{{` tokens, and is valid self-contained HTML. Proceed to Step 7.

---

### Step 7 — Deliver the Report

1. Read `config.json` for the `delivery`, `email_to`, and `slack_channel`
   values.

2. **If `delivery` is `"email"`:**
   - Use the configured email MCP connector.
   - Send the contents of `report_YYYY-MM-DD.html` as the full HTML email body.
   - To: the address in `config.json → email_to`
   - Subject: `📊 Pre-Market Report — {{DATE}} — {{BIAS}}`
     (substitute actual date and bias string)
   - Set `delivery_status = "ok"` on success, `"failed: <error>"` on failure.
   - On failure: log the error, confirm the HTML file was saved locally, and
     continue to Step 8.

3. **If `delivery` is `"slack"`:**
   - Post a plain-text summary to the channel in `config.json → slack_channel`.
   - Format the Slack message exactly as:
     ```
     --- Pre-Market Intelligence Report ---
     Date: <full date>
     Bias: <bias string>
     Indicators: <bull_count> bullish / <bear_count> bearish / <caution_count> caution

     INDICATORS:
     01. VIX → <value> (<signal>)
     02. S&P 500 Futures → <value> (<signal>)
     03. 10-Yr Treasury → <value> (<signal>)
     04. DXY → <value> (<signal>)
     05. WTI Crude → <value> (<signal>)
     06. Sector Rotation → <value> (<signal>)
     07. Earnings Catalysts → <value> (<signal>)
     08. Economic Data → <value> (<signal>)
     09. Market Breadth → <value> (<signal>)
     10. Put/Call Ratio → <value> (<signal>)

     STRATEGY SUMMARY:
     • <Key Theme 1>
     • <Key Theme 2>
     • <Key Theme 3>
     • <Opening Bell action>

     TRADES:
     1. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>
     2. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>
     3. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>
     4. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>
     5. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>
     6. <TICKER> | <DIRECTION> | Entry: <entry> → Target: <target> | Stop: <stop> | R:R <rr>

     Full report saved to: report_YYYY-MM-DD.html
     ---
     ```
   - Set `delivery_status = "ok"` on success, `"failed: <error>"` on failure.

4. **If `delivery` is `"both"`:** execute both the email step and the Slack
   step. Set `delivery_status = "ok"` only if both succeed; otherwise record
   whichever failed.

5. Regardless of delivery outcome, confirm `report_YYYY-MM-DD.html` exists
   locally.

Success criteria: report delivered (or failure logged). Proceed to Step 8.

---

### Step 8 — Log Completion

1. Determine `indicators_ok` = number of indicators with real data (not
   "unavailable").
2. Append exactly one line to `run_log.txt` in this project folder:

   ```
   YYYY-MM-DD HH:MM ET | bias=<BIAS> | indicators=<N>/10 ok | trades=6 | delivery=<delivery_status>
   ```

   Example:
   ```
   2026-04-30 08:34 ET | bias=MODERATELY BULLISH | indicators=10/10 ok | trades=6 | delivery=ok
   ```

3. If `run_log.txt` does not exist, create it with this header line first:
   ```
   # Pre-Market Intelligence System — Run Log
   # Format: DATE TIME | bias=BIAS | indicators=N/10 ok | trades=6 | delivery=status
   ```

Success criteria: one new line appended to `run_log.txt`. Pipeline complete.

---

## Error Handling Rules (Global)

- **Never abort the pipeline** because a single indicator search failed.
  Record the failure in that indicator's `value` field and continue.
- **Never abort the pipeline** because strategy or trade generation is
  incomplete. Use what was generated; note gaps inline in the HTML.
- **Never abort the pipeline** because delivery failed. Save the HTML locally
  and log the failure with the error message.
- **Never ask for human input** during execution. This routine runs fully
  unattended.
- If a file referenced in these instructions cannot be read, log the error and
  use sensible defaults (e.g. if `config.json` is unreadable, default delivery
  to saving locally only).

---

## Output Quality Rules

- Strategy HTML must contain all 6 section headers from `strategy_template.md`
- Each trade card must contain all 11 mandatory fields from `trades_template.md`; when a conditional entry trigger exists, also include the `entry_condition` field (field 12)
- Assembled HTML must be valid and self-contained (all CSS inline)
- All prices formatted as `$XXX.XX`
- All percentages formatted as `+X.X%` or `-X.X%`
- No unreplaced `{{placeholder}}` tokens in the final report
- `run_log.txt` entry must be written even if earlier steps partially failed
