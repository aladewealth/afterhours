# Phase 1 data spike — 11 Nov 2026

Times below are in **Africa/Lagos (WAT, UTC+1)** unless a source timestamp is quoted.

Probes ran around **16:00 WAT** (15:00 UTC / 10:00 ET), during the US cash session (open 09:30–16:00 ET; Veterans Day is not an NYSE holiday).

## Coinbase Tokenized Stocks API

`GET https://api.coinbase.com/v1/tokenized-stocks?page_size=500` — public, no API key, HTTP 200 in ~300ms.

**Response shape (this pull):** a single object `{ "tokens": [ ... ] }`. No `next_page_token` was present, so 338 records is the full list today. Official docs say results are paginated and a `next_page_token` may appear; the client still follows pages.

Each token always has: `contract_address`, `symbol`, `name`, `decimals` (all 8), `isin`, `multiplier`, `description`.

Optional fields (omitted when empty/default, as the docs warn):

| Field | Present |
| --- | --- |
| `adgm_isin` | 337 / 338 |
| `icon_url` | 316 / 338 |
| `total_supply` | 72 / 338 (minted) |
| `first_mint_date` | 72 / 338 |
| `nav_price` + `nav_price_updated_at` | **12 / 338** |
| `paused_features` | never present in this pull (docs: empty arrays may be omitted) |

`multiplier` is usually `1` (integer) but is a float when a corporate-action adjustment has been applied (e.g. NVDAc `1.0005379…`, GOOGLc `1.0003771…`). Docs: one token is not permanently one share; always apply the current multiplier.

**The 12 names with official NAV** (values at 16:00 WAT): AAPLc, AMZNc, CRCLc, GOOGLc, INTCc, METAc, MSFTc, MSTRc, NVDAc, SNDKc, SPCXc, TSLAc.

NAV is a Chainlink-based reference, not a live bid/ask. During the cash session, feeds update on a 0.5% deviation or a 24-hour heartbeat, so a feed can be hours old and still be “valid.” GOOGLc’s `nav_price_updated_at` was `2026-11-11T03:12:22Z` (**04:12 WAT**) — about 12 hours old during the session, classified as **Aging**, not Stale.

Addresses are B20 precompiles, all `0xb200…`. Identify tokens by address, not ticker; metadata can change.

### Other official endpoints (free, no key)

| Endpoint | Result |
| --- | --- |
| `GET /v1/tokenized-stocks/chains` | Works. Base `chain_id` `"8453"`, plus `policy_registry_address`, `token_supply_manager_address`, `token_factory_address`. Sample: `docs/samples/chains.json`. |
| `GET /v1/tokenized-stocks/metadata/AAPLc` | Works. Includes image and prospectus URLs. Ticker **must include the `c` suffix**. |
| `GET /v1/tokenized-stocks/metadata/AAPL` | HTTP 404 (`{"code":5,"message":"ticker not found: AAPL"}`). |
| `GET /v1/tokenized-stocks/total-supply/{address}` | Works. Plain number, e.g. `6248.40361951` for AAPLc (token units, not shares). |

Samples: `docs/samples/token-AAPLc.json`, `tokens-compact.json` (descriptions stripped), `metadata-AAPLc.json`.

## DEX / after-hours prices (free)

### What works

1. **Onchain Aerodrome Slipstream `slot0` via a public Base RPC — preferred.**
   - Public RPCs that answered `eth_chainId` = `0x2105` (Base): `https://mainnet.base.org`, `https://base.publicnode.com`, `https://1rpc.io/base`.
   - `https://base.llamarpc.com` failed (HTTP 525) on this probe.
   - Deepest AAPLc/USDC pool: `0xF5FCB9CDAFcE67d50AfEf298F88E709d2B946BA6`.
   - `token0` = USDC `0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913` (6 decimals), `token1` = AAPLc (8 decimals), `fee` = 502, `tickSpacing` = 10.
   - Slipstream `slot0` is the **6-field** ABI `(uint160 sqrtPriceX96, int24 tick, uint16, uint16, uint16, bool unlocked)` — **not** Uniswap V3’s 7-field ABI (the extra `uint8 feeProtocol` will fail to decode).
   - Computed onchain price: **$353.393** per AAPLc. Official NAV at the time: **$352.82** (`nav_price_updated_at` 14:33:14Z = **15:33 WAT**). Premium **+0.162%**.
   - All 12 NAV names have a deep Aerodrome USDC pool; addresses are hardcoded in `web/lib/pools.ts`. In every pool checked, USDC is `token0` because `0x8335…` sorts below `0xb200…`.

2. **DexScreener public API — works, used for liquidity/volume and as a price fallback.**
   - `GET https://api.dexscreener.com/latest/dex/tokens/{address}` is reliable per token.
   - The **batch** form (`/tokens/{addr1},{addr2},…`) returned only 30 pairs across 12 tokens and **dropped** CRCLc, TSLAc, INTCc, MSFTc, AMZNc, so the app queries one token at a time.
   - For AAPLc, DexScreener printed **$353.40** on the same pool — matches the onchain slot0 price to the cent.

3. **GeckoTerminal public API — works, not used in the app** (DexScreener + slot0 already cover it).
   - `GET /api/v2/networks/base/tokens/{address}/pools` listed many AAPLc pools. The same Aerodrome pool was top-tier. A slightly different GT USD print ($354.63) was seen on one request; treat aggregator USD as approximate and prefer onchain slot0.

### What does not / did not work well

- Official Tokenized Stocks API **does not** return a wallet’s DEX price, positions, or PnL. `nav_price` is not an execution price and is missing for 326/338 listings.
- LlamaRPC public Base endpoint was down (525) during the spike.
- UniV3-style `slot0` ABI does not decode on Aerodrome Slipstream.
- DexScreener batch cap hides names; do not rely on it for a full book.
- No paid keys were used (no Alchemy/Infura/The Graph paid plans, no CoinGecko Pro).

### DexScreener premiums at ~16:00 WAT, 11 Nov 2026

| Symbol | NAV | DEX (USDC pool) | Premium | Liq (USD) | Vol 24h (USD) |
| --- | ---: | ---: | ---: | ---: | ---: |
| SNDKc | 953.504 | 961.71 | +0.861% | 1,450,743 | 27,538,568 |
| INTCc | 61.465 | 61.88 | +0.675% | 217,496 | 86,862 |
| SPCXc | 140.455 | 141.32 | +0.616% | 869,192 | 11,610,379 |
| MSFTc | 530.681 | 528.54 | −0.403% | 451,958 | 8,883,306 |
| AMZNc | 269.562 | 268.63 | −0.346% | 1,767,300 | 10,167,538 |
| AAPLc | 352.82 | 353.40 | +0.164% | 478,996 | 4,093,942 |
| TSLAc | 388.947 | 389.52 | +0.147% | 417,389 | 6,316,538 |
| CRCLc | 66.555 | 66.64 | +0.128% | 223,043 | 104,627 |
| GOOGLc | 290.912 | 290.57 | −0.117% | 1,717,267 | 7,667,185 |
| METAc | 640.471 | 640.061 | −0.064% | 828,395 | 10,807,148 |
| MSTRc | 121.361 | 121.38 | +0.016% | 752,485 | 19,006,049 |
| NVDAc | 173.048 | 173.078 | +0.017% | 1,755,074 | 10,415,873 |

Gaps were tight because the cash session was open. The interesting AfterHours view is the same table after 16:00 ET and on weekends, when NAV feeds hold and DEX still trades.

Replay: `python3 scripts/spike_prices.py`.

## Market / feed state in the app

- **Market open/closed** uses 09:30–16:00 America/New_York, weekdays, minus a hardcoded NYSE holiday list for 2026–2027 (Veterans Day is *not* included).
- **Feed:** Live (≤2h), Aging (≤24h while cash is open), Holding (cash closed, last value held), Stale (cash open and last update older than 24h), No NAV.
- Clocks on the dashboard are shown in **WAT** and **ET**.

## Screenshot

`docs/dashboard.png` — local dashboard captured from `next dev` with a headless Chrome screenshot.
