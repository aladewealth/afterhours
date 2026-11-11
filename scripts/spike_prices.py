#!/usr/bin/env python3
"""Re-run the phase-1 data spike: Coinbase NAV + DexScreener + optional onchain AAPL."""
from __future__ import annotations

import json
import urllib.request
from pathlib import Path

API = "https://api.coinbase.com/v1/tokenized-stocks?page_size=500"
AAPL_POOL = "0xF5FCB9CDAFcE67d50AfEf298F88E709d2B946BA6"


def get(url: str) -> object:
    req = urllib.request.Request(url, headers={"User-Agent": "AfterHoursSpike/0.1", "accept": "application/json"})
    with urllib.request.urlopen(req, timeout=20) as res:
        return json.loads(res.read().decode())


def main() -> None:
    data = get(API)
    assert isinstance(data, dict)
    tokens = data.get("tokens") or []
    nav = [t for t in tokens if "nav_price" in t]
    print(f"listed={len(tokens)} with_nav={len(nav)} next_page={data.get('next_page_token')}")
    for t in nav:
        addr = t["contract_address"]
        body = get(f"https://api.dexscreener.com/latest/dex/tokens/{addr}")
        pairs = [p for p in (body.get("pairs") or []) if p.get("chainId") == "base"]
        best = None
        for p in pairs:
            if p.get("baseToken", {}).get("address", "").lower() != addr.lower():
                continue
            quote = p.get("quoteToken", {}).get("symbol")
            liq = float((p.get("liquidity") or {}).get("usd") or 0)
            score = liq + (1e12 if quote == "USDC" else 0)
            if best is None or score > best[0]:
                best = (score, quote, p.get("dexId"), p.get("pairAddress"), p.get("priceUsd"), liq)
        navp = t["nav_price"]
        if not best:
            print(f"{t['symbol']:7} NAV={navp}  NO POOL")
            continue
        px = float(best[4])
        prem = (px - navp) / navp * 100
        print(
            f"{t['symbol']:7} NAV={navp:<12} DEX={px:<10} prem={prem:+.3f}%  "
            f"liq=${best[5]:.0f} {best[2]} {best[1]} {best[3]}"
        )


if __name__ == "__main__":
    main()
