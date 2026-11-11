# AfterHours

A 24/7 terminal for Coinbase tokenized stocks on Base. It shows official NAV versus live DEX prices, and (next) lets anyone post a free onchain call on the Monday gap.

Informational only. Not investment advice, not a trading venue, no payouts.

## Repo layout

- `web/` — Next.js + Tailwind dashboard (`npm run dev`)
- `contracts/` — Foundry contract `AfterHoursBoard` (`forge test`). **Not deployed.**
- `docs/` — data-spike notes, samples, and dashboard screenshot
- `scripts/` — one-off API/DEX probes

## Run locally

```bash
# Dashboard
cd web
npm install
npm run dev
# http://localhost:3000

# Contracts
cd contracts
forge test
```

No paid API keys. The app reads:

- `https://api.coinbase.com/v1/tokenized-stocks` (public, no key)
- Base public RPCs (`mainnet.base.org`, `base.publicnode.com`, `1rpc.io/base`) for Aerodrome pool `slot0`
- DexScreener public API for liquidity / volume and as a price fallback

## What Builds needs to provide next

1. A GitHub account + repo (this tree is git-initialized and ready to push)
2. A Vercel account to host `web/`
3. A wallet address (Base Sepolia first) before any contract deploy

## Status

Phase 1: data spike, dashboard, contract + tests, local screenshot. No deploy.
