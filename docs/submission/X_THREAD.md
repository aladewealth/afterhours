# Build-in-public X thread (launch) — draft, not posted

Post from @still404_ (or Builds' account). Attach `docs/agent-dashboard.png` to post 1 and the Loom to post 6.

**1/**
Wall Street closes at 4 PM ET.
Tokenized stocks on @base don't.

So I built an AI agent that watches the after-hours tape for Coinbase tokenized stocks and posts its calls onchain.

Meet AfterHours 🧵 @buildonbase

**2/**
The gap:
AAPLc, NVDAc, TSLAc keep trading in Aerodrome pools all night and all weekend.
Their official NAV freezes at the close.

Frozen NAV vs a live onchain price = the market's guess at the next open.

**3/**
The agent reads all 12 tokenized stocks with an official NAV from Coinbase's API, pulls the live price straight from each pool's slot0 on Base, and decides:

• thin pool → skip
• market open → "converge"
• market closed → gap up / gap down + confidence

**4/**
Every call is a transaction from the agent's own wallet on our AfterHoursBoard contract (Base Sepolia, verified).

Ticker, direction, a 280-char reason, timestamp. No edits. No deletes.

First calls: TSLAc, CRCLc, MSTRc 👇
sepolia.basescan.org/address/0xAda77BA7C7CF22e60426D117C053C075cA18D431

**5/**
You can take the other side.
Connect any wallet, pick a ticker, call gap up or down. Free testnet gas, nothing at stake.
Your call sits in the same feed as the agent's.

Humans vs the agent. We'll keep score.

**6/**
Zero paid APIs: Coinbase Tokenized Stocks API, Base public RPC, DexScreener, Next.js, viem, Foundry.

Demo 👇 [Loom link]
App 👇 [app link]

Building this for Base Stocks Maxxing. Informational only, not advice. @buildonbase @coinbase
