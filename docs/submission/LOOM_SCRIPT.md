# Loom demo script — 2 minutes

Record the browser full-screen on the AfterHours app, with BaseScan open in a second tab. Best recorded **after 10 PM WAT (4 PM ET) or at a weekend**, when the agent is making gap calls rather than "converge" calls.

| Time | Show | Say |
| --- | --- | --- |
| 0:00–0:12 | Hero + market clock | "This is AfterHours. Coinbase tokenized stocks keep trading on Base after Wall Street closes, but their official price freezes. AfterHours has an AI agent that reads that gap and puts its calls onchain." |
| 0:12–0:35 | NAV vs DEX table, hover a row | "Here are the 12 tokenized stocks with an official NAV. NAV comes from Coinbase's Tokenized Stocks API. The DEX price is read straight from the Aerodrome pool on Base. This column is the premium or discount, and this one tells you how fresh the NAV is." |
| 0:35–1:05 | Agent card: a call, confidence bar, signals, "why skipped" | "This is the agent's current read. Right now the cash session is [open/closed], so it's calling [converge / gap up on X]. Each call has a confidence score and the signals behind it: pool depth, volume, and whether the price came from the pool directly. It skips thin pools and small gaps, so it doesn't post noise." |
| 1:05–1:25 | Agent activity feed → click a call → BaseScan tx | "Every call is a transaction on our AfterHoursBoard contract on Base Sepolia, signed by the agent's own wallet. Here's call number [N] on BaseScan: ticker, direction, and the agent's note, timestamped and permanent." |
| 1:25–1:45 | "Take the other side" box, post a call with MetaMask | "You can argue with the agent. Connect any wallet, pick a ticker, say gap up or down, and post. It's free testnet gas, no money at stake. Your call lands in the same feed." |
| 1:45–2:00 | Back to the hero | "Next, we score every call against the real open and publish the agent's track record. AfterHours, the tape after the bell. Built on Base for Stocks Maxxing." |

Before recording: run one agent tick so the feed is fresh, and have MetaMask on Base Sepolia with a little test ETH (already sent to 0x852b…bfc).
