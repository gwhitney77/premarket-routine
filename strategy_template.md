# Strategy Output Template

This file defines the required sections, content rules, and HTML formatting
for the daily strategy briefing generated in Step 4 of CLAUDE.md.

---

## Required Sections (all mandatory, in this exact order)

### Section 1 — Overall Market Bias

A single bold sentence declaring the day's verdict. Incorporate the bias
string from Step 3 and the dominant signal that drove it.

Wrap in: `<div class="highlight"><strong>…</strong></div>`

Example content:
> Today's market is **MODERATELY BULLISH**, driven by contained volatility,
> rising futures, and cyclical sector leadership outweighing a mildly
> cautious Treasury yield environment.

---

### Section 2 — Key Themes

3–4 bullet points identifying the dominant forces driving price action today.
Each bullet should name a specific indicator or data point and explain its
implication.

Use `<span class="bull">` for bullish themes, `<span class="bear">` for
bearish themes, `<span class="caution">` for caution themes.

Example bullets:
- VIX at 14.2 confirms a <span class="bull">low-fear, risk-on</span> backdrop
- Treasury yields sliding -4bps signals <span class="bull">rate-cut optimism</span>
- Mega-cap earnings beat sets a <span class="bull">positive tone</span> for tech
- Fed speaker at 10 AM creates <span class="caution">midday headline risk</span>

---

### Section 3 — Opportunities

Specific sectors, setups, or catalysts worth pursuing today. 3–5 bullets.
Be concrete: name sectors, sub-industries, or individual setups. Explain why
each opportunity is relevant given today's indicator readings.

Example bullets:
- Technology (XLK) is the leading sector; momentum setups in large-cap
  semis offer the best R:R for the open
- Financials (XLF) benefit from the steepening yield curve today
- Energy longs are viable if WTI holds the $78 level after the overnight bid

---

### Section 4 — Risks & Warnings

What could invalidate the day's bullish or bearish thesis. 3–4 bullets.
Include specific price levels, events, or conditions that would trigger a
reassessment.

Use `<span class="bear">` and `<span class="caution">` to colour risk items.

Example bullets:
- A <span class="bear">VIX spike above 20</span> intraday would signal a
  shift to risk-off and invalidate long setups
- The <span class="caution">Fed speaker at 10 AM</span> could reprice rate
  expectations; avoid entering large positions before the comment window
- If S&P 500 fails to hold <span class="bear">5,580 support</span> on the
  cash open, the bullish thesis weakens materially

---

### Section 5 — Opening Bell Plan

Step-by-step action plan for the first 30–60 minutes of the session.
Use numbered steps (render as `<ol><li>`). Be tactical and time-specific.

Example steps:
1. 8:30 AM — Review this report. Confirm futures haven't gapped significantly
   versus overnight levels.
2. 9:00–9:30 AM — Watch for any pre-open news; avoid entering before 9:30 AM
   unless a specific catalyst trade is set up.
3. 9:30–9:45 AM — Observe the opening range on SPY/QQQ. Do not chase; wait
   for a 5-minute bar confirmation of direction.
4. 9:45–10:00 AM — Enter highest-conviction trades with defined stops.
5. 10:00 AM — Monitor Fed speaker headlines; tighten stops on open positions
   if language shifts hawkish.
6. 10:30 AM — Re-evaluate open positions against sector rotation and breadth.

---

### Section 6 — Key Levels to Watch

Support, resistance, and trigger price levels for the major indices and any
particularly relevant tickers. Include at least: SPY, QQQ, and one bond/
volatility level.

Render as a definition-style list using `<ul><li>`.

Example entries:
- **SPY** — Support: $554.50 / Resistance: $560.00 / Trigger: close above
  $558 confirms trend continuation
- **QQQ** — Support: $470.00 / Resistance: $478.50
- **VIX** — Watch 20.00 as the fear threshold; breach changes the game plan
- **10Y Yield** — 4.65% is the pivot; a move above that level pressures tech

---

## HTML Formatting Rules

These rules must be followed exactly. No markdown syntax — HTML only.

```html
<!-- Section 1 — Overall Market Bias -->
<div class="highlight">
  <strong>Today's market is MODERATELY BULLISH…</strong>
</div>

<!-- Section 2 — Key Themes -->
<h3>Key Themes</h3>
<ul>
  <li><span class="bull">Bullish item…</span></li>
  <li><span class="bear">Bearish item…</span></li>
  <li><span class="caution">Caution item…</span></li>
</ul>

<!-- Section 3 — Opportunities -->
<h3>Opportunities</h3>
<ul>
  <li>…</li>
</ul>

<!-- Section 4 — Risks & Warnings -->
<h3>Risks &amp; Warnings</h3>
<ul>
  <li><span class="bear">…</span></li>
</ul>

<!-- Section 5 — Opening Bell Plan -->
<h3>Opening Bell Plan</h3>
<ol>
  <li>…</li>
</ol>

<!-- Section 6 — Key Levels to Watch -->
<h3>Key Levels to Watch</h3>
<ul>
  <li><strong>SPY</strong> — Support: … / Resistance: …</li>
</ul>
```

### CSS classes referenced above (defined in report_template.html `<style>` block):

| Class        | Color    | Use for                            |
|--------------|----------|------------------------------------|
| `.bull`      | #16a359  | Bullish text highlights            |
| `.bear`      | #e84040  | Bearish text highlights            |
| `.caution`   | #d4a010  | Caution / warning text highlights  |
| `.highlight` | background #1a2d4a, border-left 3px solid #16a359 | Key verdict box |

### Word count limit

Maximum **600 words** across all 6 sections combined. Be precise and tactical;
avoid padding.
