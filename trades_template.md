# Trade Recommendations Template

This file defines the 11 mandatory fields and the exact HTML card structure
for each of the 6 trade recommendations generated in Step 5 of CLAUDE.md.

---

## 11 Mandatory Fields Per Trade

All fields are required. Do not omit or leave blank. If a field cannot be
determined, write `"N/A — [reason]"`.

| # | Field        | Type     | Format / Rules                                              |
|---|--------------|----------|-------------------------------------------------------------|
| 1 | `ticker`     | string   | All caps. Real, actively traded symbol. E.g. `NVDA`         |
| 2 | `name`       | string   | Full company or ETF name. E.g. `NVIDIA Corporation`         |
| 3 | `direction`  | enum     | Exactly one of: `LONG` / `SHORT` / `HEDGE`                  |
| 4 | `thesis`     | string   | 1–2 sentences. Why this setup, why today. Be specific.      |
| 5 | `entry`      | price    | Entry price or zone. Format: `$XXX.XX` or `near $XXX.XX`   |
| 6 | `stop`       | price    | Stop-loss level. Format: `$XXX.XX`                          |
| 7 | `target`     | price    | Profit target. Format: `$XXX.XX`                            |
| 8 | `rr`         | ratio    | Risk/reward. Format: `1:X.X`                                |
| 9 | `conviction` | enum     | Exactly one of: `HIGH` / `MEDIUM` / `LOW`                   |
|10 | `timing`     | enum     | Exactly one of: `intraday` / `opening 30min` / `swing 2-3d` |
|11 | `catalyst`   | string   | 1 sentence. What makes this timely today specifically.      |

### R:R Calculation Rules

- **LONG:**  R:R = `(target − entry) / (entry − stop)`. Format as `1:X.X`.
- **SHORT:** R:R = `(entry − target) / (stop − entry)`. Format as `1:X.X`.
- **HEDGE:** R:R = estimate based on max loss (premium paid or entry vs. stop)
  vs. max gain scenario.
- Round to one decimal place.

### Trade Mix Rules (from CLAUDE.md Step 5)

- 2–3 LONG trades in the strongest sectors identified from indicators
- 1–2 SHORT or bearish plays on the weakest sectors
- 1 HEDGE or volatility play (e.g. VIX ETF, inverse ETF, or defined-risk
  options structure described as a stock/ETF setup)

---

## HTML Card Structure

Each trade must be rendered as a self-contained HTML card with **all CSS
inline**. No external stylesheets. Cards are concatenated and inserted into
`{{TRADES}}` in report_template.html.

### Card Template

```html
<div style="
  background: #0d1220;
  border: 1px solid #1e3a5f;
  border-top: 3px solid {{DIRECTION_COLOR}};
  border-radius: 8px;
  padding: 16px 20px;
  margin-bottom: 16px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
">

  <!-- Header row: ticker + direction badge -->
  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
    <div>
      <span style="font-size: 20px; font-weight: 700; color: #e8f0fe; letter-spacing: 1px;">
        {{TICKER}}
      </span>
      <span style="font-size: 13px; color: #5a7da8; margin-left: 8px;">
        {{NAME}}
      </span>
    </div>
    <span style="
      background: {{DIRECTION_COLOR}};
      color: #fff;
      font-size: 10px;
      font-weight: 700;
      letter-spacing: 1.5px;
      padding: 3px 8px;
      border-radius: 3px;
    ">{{DIRECTION}}</span>
  </div>

  <!-- Thesis -->
  <p style="color: #a8c0e8; font-size: 13px; margin: 0 0 12px 0; line-height: 1.5;">
    {{THESIS}}
  </p>

  <!-- Entry / Stop / Target row -->
  <div style="display: flex; gap: 12px; margin-bottom: 12px;">
    <div style="flex: 1; background: #0a0e1a; border-radius: 6px; padding: 8px 10px; text-align: center;">
      <div style="font-size: 10px; color: #5a7da8; letter-spacing: 0.8px; margin-bottom: 3px;">ENTRY</div>
      <div style="font-size: 15px; font-weight: 600; color: #e8f0fe;">{{ENTRY}}</div>
    </div>
    <div style="flex: 1; background: #0a0e1a; border-radius: 6px; padding: 8px 10px; text-align: center;">
      <div style="font-size: 10px; color: #5a7da8; letter-spacing: 0.8px; margin-bottom: 3px;">STOP</div>
      <div style="font-size: 15px; font-weight: 600; color: #e84040;">{{STOP}}</div>
    </div>
    <div style="flex: 1; background: #0a0e1a; border-radius: 6px; padding: 8px 10px; text-align: center;">
      <div style="font-size: 10px; color: #5a7da8; letter-spacing: 0.8px; margin-bottom: 3px;">TARGET</div>
      <div style="font-size: 15px; font-weight: 600; color: #16a359;">{{TARGET}}</div>
    </div>
  </div>

  <!-- R:R + Conviction row -->
  <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
    <div>
      <span style="font-size: 11px; color: #5a7da8;">R:R </span>
      <span style="font-size: 14px; font-weight: 700; color: #c8922a;">{{RR}}</span>
    </div>
    <div style="display: flex; align-items: center; gap: 6px;">
      <span style="font-size: 11px; color: #5a7da8;">Conviction</span>
      {{CONVICTION_DOTS}}
    </div>
  </div>

  <!-- Footer: timing + catalyst -->
  <div style="
    border-top: 1px solid #1e3a5f;
    padding-top: 8px;
    margin-top: 4px;
    font-size: 11px;
    color: #5a7da8;
    line-height: 1.6;
  ">
    <span style="color: #2a4a7f; text-transform: uppercase; letter-spacing: 0.8px; font-size: 10px;">Timing: </span>{{TIMING}}
    &nbsp;|&nbsp;
    <span style="color: #2a4a7f; text-transform: uppercase; letter-spacing: 0.8px; font-size: 10px;">Catalyst: </span>{{CATALYST}}
  </div>

</div>
```

---

## Placeholder Reference

Replace each token when rendering a card:

| Token                | Replace with                                                  |
|----------------------|---------------------------------------------------------------|
| `{{DIRECTION_COLOR}}`| `#16a359` (LONG) / `#e84040` (SHORT) / `#d4a010` (HEDGE)    |
| `{{TICKER}}`         | Ticker symbol in caps                                         |
| `{{NAME}}`           | Full company/ETF name                                         |
| `{{DIRECTION}}`      | LONG / SHORT / HEDGE                                          |
| `{{THESIS}}`         | 1–2 sentence setup rationale                                  |
| `{{ENTRY}}`          | Entry price, e.g. `$147.50`                                   |
| `{{STOP}}`           | Stop-loss price, e.g. `$144.00`                               |
| `{{TARGET}}`         | Target price, e.g. `$155.00`                                  |
| `{{RR}}`             | Risk/reward ratio, e.g. `1:2.4`                               |
| `{{CONVICTION_DOTS}}`| Dot HTML (see below)                                          |
| `{{TIMING}}`         | intraday / opening 30min / swing 2-3d                         |
| `{{CATALYST}}`       | One-sentence timing rationale                                 |

---

## Conviction Dot Rendering

Render `{{CONVICTION_DOTS}}` as inline `<span>` dots.

- **HIGH** conviction: 4 filled dots + 0 empty
  - Filled color: `#16a359`
- **MEDIUM** conviction: 3 filled dots + 1 empty
  - Filled color: `#d4a010`
- **LOW** conviction: 2 filled dots + 2 empty
  - Filled color: `#e84040`
- Empty dot color (all levels): `#1e3a5f`
- Dot character: `●` (U+25CF), font-size 14px

### Examples

HIGH:
```html
<span style="color:#16a359;font-size:14px;">●</span>
<span style="color:#16a359;font-size:14px;">●</span>
<span style="color:#16a359;font-size:14px;">●</span>
<span style="color:#16a359;font-size:14px;">●</span>
```

MEDIUM:
```html
<span style="color:#d4a010;font-size:14px;">●</span>
<span style="color:#d4a010;font-size:14px;">●</span>
<span style="color:#d4a010;font-size:14px;">●</span>
<span style="color:#1e3a5f;font-size:14px;">●</span>
```

LOW:
```html
<span style="color:#e84040;font-size:14px;">●</span>
<span style="color:#e84040;font-size:14px;">●</span>
<span style="color:#1e3a5f;font-size:14px;">●</span>
<span style="color:#1e3a5f;font-size:14px;">●</span>
```
