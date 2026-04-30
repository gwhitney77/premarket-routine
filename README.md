# Pre-Market Intelligence System

## What this is

This is a **Claude Code Routine** — not a Python script, not a cron job, not a
daemon. Claude itself is the runtime. The `CLAUDE.md` file is the program: it
contains the complete, ordered instructions that the Claude Code agent reads
and executes autonomously at each scheduled run. Claude Code's managed cloud
infrastructure handles the schedule, the web searches, the reasoning, the HTML
assembly, and the delivery — no code runs on your machine during a scheduled
execution.

---

## How it works

```
[claude.ai/code Routine scheduler]
       │  fires at 8:30 AM ET Mon–Fri
       ▼
[Claude Code agent reads CLAUDE.md]
       │
       ▼
[Step 1: market day check]
  Is today a weekday? Is it in skip_dates?
  └─ NO  → output "Non-trading day" and stop
  └─ YES → continue
       │
       ▼
[Steps 2–3: 10 web searches → indicator results → bias score]
  VIX · S&P Futures · 10Y Yield · DXY · WTI Oil
  Sector Rotation · Earnings · Econ Data · Breadth · Put/Call
  └─ Count bullish / bearish / caution signals
  └─ Determine overall bias string + color
       │
       ▼
[Step 4: strategy synthesis]
  6-section HTML strategy briefing written by Claude
  (bias verdict · themes · opportunities · risks · open plan · levels)
       │
       ▼
[Step 5: 6 trade recommendations]
  2-3 longs · 1-2 shorts · 1 hedge
  Real tickers · real prices · entry/stop/target/R:R
       │
       ▼
[Step 6: HTML report assembly]
  Reads report_template.html
  Replaces all {{placeholders}} with live data
  Saves report_YYYY-MM-DD.html locally
       │
       ▼
[Step 7: delivery via MCP connector]
  email  → HTML email to config.json → email_to
  slack  → plain-text summary to config.json → slack_channel
  both   → email AND Slack
       │
       ▼
[Step 8: run_log.txt entry]
  One line: date · bias · indicators ok · trades · delivery status
```

---

## Prerequisites

- **Claude Code CLI** installed:
  ```bash
  curl -fsSL https://claude.ai/install.sh | bash
  ```
- **Claude account** — Pro, Max, Team, or Enterprise
  (Routines require Claude Code on the web to be enabled)
- **Claude Code web access** enabled at [claude.ai/code](https://claude.ai/code)
- **MCP connector** configured in Claude Code:
  - Email connector — for `delivery: "email"` or `"both"`
  - Slack connector — for `delivery: "slack"` or `"both"`

---

## Setup (do this once)

**Step 1** — Copy this project folder to your machine.

**Step 2** — Edit `config.json`:
```json
{
  "delivery": "email",
  "email_to": "yourname@example.com"
}
```
Set `delivery` to `email`, `slack`, or `both`. Set `email_to` and/or
`slack_channel` to match.

**Step 3** — Update `skip_dates` in `config.json` with the current year's
US market holidays (the file ships with 2026 holidays pre-filled).

**Step 4** — Run a manual test to verify everything works:
```bash
cd premarket-routine
bash run_manual.sh
```
Confirm a `report_YYYY-MM-DD.html` file is created and delivered.

**Step 5** — Register the Routine (choose one method):

### Method A — Web UI (easiest)

1. Go to [claude.ai/code](https://claude.ai/code)
2. Click **New Routine**
3. Name it: `Pre-Market Intelligence`
4. **Task**: paste the full contents of `CLAUDE.md`
5. **Schedule**: Weekdays, 08:30 AM Eastern Time
   _(cron equivalent: `30 8 * * 1-5` in US/Eastern timezone)_
6. **Working directory**: point to this project folder
7. Enable the **email** or **Slack** MCP connector as needed
8. Click **Save**

### Method B — CLI (from inside this project folder)

```bash
claude
/schedule "Run the pre-market intelligence routine as defined in CLAUDE.md" --cron "30 8 * * 1-5"
```

> **Note:** The minimum schedule interval for Claude Code Routines is 1 hour.
> The 8:30 AM weekday schedule (once per weekday morning) satisfies this.

---

## Daily limit awareness

| Plan         | Routine runs per day | This routine uses |
|--------------|----------------------|-------------------|
| Pro          | 5                    | 1                 |
| Max          | 15                   | 1                 |
| Team         | 25                   | 1                 |
| Enterprise   | 25                   | 1                 |

This routine fires once per weekday morning — well within all plan limits.
One run = one full sweep (10 indicator searches + strategy + 6 trades + delivery).

---

## Manual test run

From inside the `premarket-routine/` directory:
```bash
bash run_manual.sh
```

This executes the full pipeline immediately using the same `CLAUDE.md`
instructions as the scheduled Routine. Useful for testing configuration
changes, verifying MCP delivery, or generating a report on demand.

---

## Monitoring your Routine

- **Execution history**: [claude.ai/code](https://claude.ai/code) → Routines → Pre-Market Intelligence
- **Local log**: `run_log.txt` in this folder — one line per run
- **Reports**: saved locally as `report_YYYY-MM-DD.html`

---

## Modifying the routine

All configuration is in flat files — no code to edit.

| To change…                    | Edit this file             | Notes                          |
|-------------------------------|----------------------------|--------------------------------|
| Indicator definitions         | `indicators.md`            | Add/remove/modify indicators   |
| Strategy section format       | `strategy_template.md`     | Layout and HTML rules          |
| Trade card format             | `trades_template.md`       | Fields and HTML card structure |
| Email/report HTML layout      | `report_template.html`     | Full dark-theme template       |
| Delivery, email, skip dates   | `config.json`              | Main settings file             |
| Pipeline logic / steps        | `CLAUDE.md`                | Core agent instructions        |

Changes take effect on the next scheduled run — no re-registration needed,
as long as `CLAUDE.md` still references the support files by their current names.

---

## Troubleshooting

| Issue | Solution |
|---|---|
| Routine not firing | Check [claude.ai/code](https://claude.ai/code) → Routines — confirm it shows as **Active** |
| No email received | Verify email MCP connector is enabled for this Routine |
| Report saves locally but email fails | Check MCP connector auth — reconnect if needed |
| Indicator shows "unavailable" | Web search returned no data — usually resolves next run |
| `run_manual.sh` fails | Confirm claude CLI is installed: `claude --version` |
| Wrong timezone | Confirm schedule is set to US/Eastern at claude.ai/code |
| Runs on weekends | Verify Step 1 in `CLAUDE.md` — check the weekday logic |
| `config.json` parse error | Validate with: `python3 -m json.tool config.json` |

---

## File structure

```
premarket-routine/
├── CLAUDE.md              ← Routine task definition (the agent's brain)
├── config.json            ← User settings (delivery, email, skip dates)
├── indicators.md          ← 10 indicator definitions & search queries
├── strategy_template.md   ← Strategy output structure & HTML rules
├── trades_template.md     ← Trade card fields & HTML card structure
├── report_template.html   ← Dark-theme HTML email template
├── run_manual.sh          ← One-liner manual test trigger
├── README.md              ← This file
├── run_log.txt            ← Created on first run; one line per execution
└── report_YYYY-MM-DD.html ← Created on each run; today's report
```

---

## Disclaimer

For educational purposes only. Not financial advice. Trading involves
substantial risk of loss. Past signals are not predictive of future results.
Always apply your own judgement and risk management before making any trade.
