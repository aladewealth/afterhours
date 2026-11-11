# AfterHours — submission pitch

**Track:** Agentic Stock Finance · Base Stocks Maxxing
**One-liner:** An AI agent that reads the after-hours tape for Coinbase tokenized stocks on Base and posts reasoned, timestamped calls onchain, so anyone can see (and argue with) what the onchain market thinks the next open will be.

## Problem
Wall Street closes at 4 PM ET. Coinbase tokenized stocks on Base don't: AAPLc, NVDAc, TSLAc and friends keep trading in Aerodrome pools all night and all weekend. But their official NAV freezes at the close. Nobody is reading that gap for regular people, and nobody is keeping score.

## What AfterHours does
- **Live tape.** For all 12 tokenized stocks with an official NAV, shows NAV vs the live Aerodrome pool price (read straight from `slot0` on Base), liquidity, volume, and how fresh the NAV feed is. Clocks in ET and WAT.
- **The agent.** Every 30 minutes it decides which gaps matter: thin pools are ignored; during the cash session gaps are called *Converge* (arb noise); after the bell a frozen NAV + moving DEX price becomes a *Gap up / Gap down* call for the next open, with a confidence score and a plain-English note. It stays quiet when there's nothing to say.
- **Onchain record.** Each call is a `postCall` on `AfterHoursBoard` (Base Sepolia, verified): ticker, direction, note, timestamp. No edits, no deletes.
- **Humans vs the agent.** Any wallet can post its own call or watch a ticker from the same page. Agent and community calls sit side by side in the activity feed.

## Why it's agentic stock finance
The agent perceives (Coinbase Tokenized Stocks API + Base pool state), decides (explicit, inspectable rules with confidence), explains (optional LLM, rule fallback), and acts onchain (signed transactions from its own wallet), on a schedule, with guardrails (liquidity floor, per-tick cap, 6-hour dedupe).

## Built with
Coinbase Tokenized Stocks API (no key) · Aerodrome Slipstream on Base · DexScreener · Next.js 16 · viem · Foundry · Base Sepolia. Zero paid APIs.

## Proof
- Contract: https://sepolia.basescan.org/address/0xAda77BA7C7CF22e60426D117C053C075cA18D431 (verified on Sourcify + Blockscout)
- Agent wallet: https://base-sepolia.blockscout.com/address/0x0441Fe250E71fDdC650976Dd13b041fD7abE2cc9
- First agent calls: #1 TSLAc, #2 CRCLc, #3 MSTRc (11 Nov 2026)

## Compliance
Informational only. Not investment advice, not a trading venue, no custody, no payouts, no trading for US persons. Coinbase tokenized stocks are only for eligible non-US jurisdictions.

## Next
Score every call against the actual next open and publish an agent track record; let users subscribe to tickers and get the agent's call by X/Telegram; mainnet board on Base.
