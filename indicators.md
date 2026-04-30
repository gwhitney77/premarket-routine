# Pre-Market Intelligence System — Indicator Definitions

For each indicator below:
- Use the exact **Search Query** when calling web search in Step 2
- Apply the **Signal Rules** to determine the signal value
- Record name, value, context (1 sentence), signal, and detail (2–3 sentences)

---

## 01. VIX — CBOE Volatility Index

**Search Query:** `VIX CBOE volatility index current level today`

**What it measures:** Market fear and expected near-term volatility in the
S&P 500 options market. Often called the "fear gauge."

**Signal Rules:**
- `bullish`  → VIX **below 15** (low fear, risk-on environment)
- `neutral`  → VIX **15–20** (normal operating range)
- `caution`  → VIX **20–30** (elevated uncertainty, be selective)
- `bearish`  → VIX **above 30** (high fear, risk-off, reduce exposure)

**Context note:** A VIX spike of +20% or more intraday is itself a caution
signal regardless of absolute level.

---

## 02. S&P 500 Futures (ES)

**Search Query:** `S&P 500 ES futures premarket today price percentage change`

**What it measures:** Overnight and pre-market directional sentiment for the
broad US equity market. Leading indicator for cash open.

**Signal Rules:**
- `bullish`  → futures **up more than +0.3%** (positive open expected)
- `neutral`  → futures **within +/- 0.3%** (flat open expected)
- `bearish`  → futures **down more than -0.3%** (negative open expected)
- `caution`  → futures gap of **more than +/- 1.0%** (large overnight gap,
  elevated fade/fill risk regardless of direction)

**Context note:** If both bullish direction AND caution threshold are triggered
(e.g. futures +1.2%), assign `caution` as the primary signal and note the gap
magnitude in the detail field.

---

## 03. 10-Year US Treasury Yield

**Search Query:** `10 year US Treasury yield today current rate`

**What it measures:** Risk-free rate benchmark. Drives valuation multiples for
equities, especially growth and technology names. Reflects rate-cut
expectations and inflation bets.

**Signal Rules:**
- `bullish`  → yield **falling** on the day (money rotating to safety or
  growing rate-cut bets; positive for growth/tech valuations)
- `neutral`  → yield **stable** day-over-day (less than ±3 basis points)
- `bearish`  → yield **rising sharply** on the day (pressure on growth/tech
  valuations; mortgage and credit markets tighten)
- `caution`  → yield **above 4.75% or below 3.5%** (extreme range; equity
  valuations under structural pressure at highs, deflation risk at lows)

**Context note:** Always record the absolute yield level AND the direction of
change. Both matter for the context sentence.

---

## 04. US Dollar Index (DXY)

**Search Query:** `US dollar index DXY current level today forex`

**What it measures:** Strength of the US dollar against a basket of six major
currencies. Inverse relationship with risk assets, commodities, and
multinational earnings.

**Signal Rules:**
- `bullish`  → DXY **falling** on the day (tailwind for commodities, EM, and
  US multinationals reporting in foreign currencies)
- `neutral`  → DXY **flat** on the day (less than ±0.2% change)
- `bearish`  → DXY **rising** on the day (headwind for commodities, EM, and
  multinational earnings)
- `caution`  → DXY move **greater than +/- 0.5% in a single session** (sharp
  FX moves can cause dislocations across asset classes)

**Context note:** Record both the absolute DXY level and its percentage change
on the day.

---

## 05. WTI Crude Oil

**Search Query:** `WTI crude oil price today premarket current per barrel`

**What it measures:** Global energy demand and supply balance. Proxy for
economic activity. Directly affects energy sector stocks and, at extremes,
inflation expectations.

**Signal Rules:**
- `bullish`  → oil **rising moderately** (+0.5% to +2.9%) — energy sector
  strength without inflationary concern
- `neutral`  → oil **flat to slightly positive** (less than ±0.5%)
- `bearish`  → oil **falling sharply** (more than -2%) — demand concerns or
  macro weakness signal
- `caution`  → oil move **greater than +/- 3%** in a session (inflationary
  spike risk on the upside; demand crash signal on the downside)

**Context note:** Record price per barrel, direction, and percentage change.
Note any OPEC decisions, inventory data, or geopolitical events if surfaced in
the search results.

---

## 06. Sector Rotation — Leaders & Laggards

**Search Query:** `S&P 500 sector ETF performance today premarket XLK XLF XLE XLV XLY leaders laggards`

**What it measures:** Which parts of the market are attracting or losing money.
Cyclical leadership signals risk appetite; defensive leadership signals
caution or risk-off sentiment.

**Signal Rules:**
- `bullish`  → **cyclicals leading**: XLY (Consumer Discretionary), XLF
  (Financials), XLI (Industrials), or XLK (Technology) are top performers;
  defensives (XLU, XLP, XLRE) are lagging
- `bearish`  → **defensives leading**: XLU (Utilities), XLP (Staples), or
  XLRE (Real Estate) are top performers; cyclicals are underperforming
- `caution`  → defensive rotation happening simultaneously with high VIX
  (flight to safety underway)
- `neutral`  → no clear sector leadership; performance spread is less than
  0.3% across major sectors

**Context note:** Name the top 2–3 performing sectors and the bottom 2 in the
context and detail fields.

---

## 07. Earnings Catalysts

**Search Query:** `major earnings reports today premarket after hours stock movers reaction`

**What it measures:** Whether major earnings releases are driving index-level
moves or creating significant sector/stock opportunities.

**Signal Rules:**
- `bullish`  → large-cap beats are **driving index futures higher**; positive
  guidance revisions in play
- `bearish`  → large-cap misses are **dragging index futures lower**; negative
  guidance or revenue warnings
- `caution`  → major miss or negative surprise from a **mega-cap name**
  (AAPL, MSFT, NVDA, AMZN, META, GOOGL, TSLA) — systemic index impact
- `neutral`  → no major earnings releases today, or results are mixed with no
  clear directional index impact

**Context note:** Name any specific companies reporting and their approximate
reaction if available. Note whether the reaction is pre-market or after-hours
from the prior session.

---

## 08. Economic Data Releases

**Search Query:** `economic data scheduled today CPI jobs GDP Fed speaker FOMC market moving`

**What it measures:** Scheduled macro data releases and Fed communication that
can override technical setups and cause rapid repricing.

**Signal Rules:**
- `bullish`  → no major data scheduled today, or data previously released
  came in benign (in-line or better-than-expected on inflation/jobs)
- `bearish`  → **hot inflation data** (CPI/PPI above consensus) or **weak
  jobs data** (payrolls miss, rising unemployment) due or released today
- `caution`  → **Fed Chair speaking** today, or **FOMC decision/minutes**
  release today; also applies if multiple high-impact events are clustered
- `neutral`  → only minor data scheduled (housing permits, regional surveys),
  no market-moving events expected

**Context note:** List the specific data releases scheduled for today with
their expected release times if found in search results. Flag any Fed speakers.

---

## 09. Market Breadth — Advance/Decline

**Search Query:** `NYSE market breadth advance decline line today premarket`

**What it measures:** Whether the market's move (up or down) is broad and
healthy, or narrow and potentially unsustainable.

**Signal Rules:**
- `bullish`  → breadth **improving**: advancers broadly exceeding decliners;
  more stocks participating in any rally
- `bearish`  → breadth **deteriorating**: narrow market leadership, most
  stocks declining even if the index holds up due to mega-cap weight
- `caution`  → index near **highs but breadth diverging** — fewer stocks
  making new highs, advance/decline line turning down (distribution signal)
- `neutral`  → breadth is **in line** with index performance; no notable
  divergence in either direction

**Context note:** If exact advance/decline numbers are available, record them.
Otherwise describe the qualitative breadth picture from search results.

---

## 10. Put/Call Ratio & Options Sentiment

**Search Query:** `CBOE put call ratio today options sentiment fear greed`

**What it measures:** Options market positioning and crowd sentiment. Acts as a
contrarian indicator — extreme fear (high P/C) often marks bottoms; extreme
complacency (low P/C) often marks tops.

**Signal Rules:**
- `bullish`  → P/C ratio **above 1.2** — excessive fear/hedging in the market;
  contrarian buy signal (too many bears)
- `neutral`  → P/C ratio **between 0.8 and 1.1** — normal balanced sentiment
- `bearish`  → P/C ratio **below 0.7** — excessive complacency; contrarian
  sell signal (too many bulls, insufficient hedging)
- `caution`  → **extreme reading above 1.5 or below 0.6** — sentiment has
  reached a historically rare extreme; mean reversion risk elevated

**Context note:** Record the specific P/C ratio value. Note whether it is
trending toward more fear or more complacency versus recent sessions.
