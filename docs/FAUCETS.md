# Base Sepolia faucets

## ✅ What worked (11 Nov 2026, 16:48 WAT)

**A2AWire agent faucet — no login, no captcha, curl-able.** 0.0005 Base Sepolia ETH per address per 24h.

```bash
curl -sS -X POST https://a2awire.com/agents/faucet/invoke \
  -H "Content-Type: application/json" \
  -d '{"task":"request_testnet_eth","input":{"address":"0xYOUR_ADDRESS"}}'
```

Funded the deployer in tx `0xea86f2134d779c1f3be1a425f519ad268f36e360728b16c451a728e60ee0742b`. Deploying `AfterHoursBoard` cost ~0.000002 ETH and each agent `postCall` costs well under 0.000001 ETH (gas ~0.006 gwei), so 0.0005 ETH covers hundreds of agent calls.

Tried and dead: Lumina faucet (`lumina-api-production-ac85.up.railway.app`, “Application not found”), pow.zalalena.com (hCaptcha required before mining).

## For Builds' MetaMask (0x852b3bDBb2e68eBF41fCF304E4128f4E82897bfc), from a phone

1. **Same A2AWire faucet** — any curl/HTTP client, or ask the agent to call it for your address. Easiest.
2. **Coinbase CDP faucet** — https://portal.cdp.coinbase.com/products/faucet (free CDP account, 0.0001 ETH per click, up to 0.1/day).
3. **Google Cloud Web3 faucet** — https://cloud.google.com/application/web3/faucet/base/sepolia (Google sign-in + captcha).
4. **Superchain faucet** — https://console.optimism.io/faucet/ (GitHub sign-in).

Then add Base Sepolia to MetaMask (chain 84532, RPC https://sepolia.base.org) — the AfterHours “Post call” button does this for you.

---

# Earlier notes (phase 1.5)

Deployer (public, testnet-only): `0x0441Fe250E71fDdC650976Dd13b041fD7abE2cc9`

Paste that address into a faucet. Never paste a private key or seed phrase into a faucet.

Checked 11 Nov 2026, afternoon WAT. The deployer balance on `https://sepolia.base.org` was **0**. No faucet accepted a login-free programmatic claim.

## Best options (no mainnet ETH, no card)

These need a **browser** (login, GitHub, captcha, wallet connect, or in-tab mining). Official Base docs: https://docs.base.org/get-started/get-funds

1. **Coinbase Developer Platform (recommended)**  
   https://portal.cdp.coinbase.com/products/faucet  
   Free CDP account, **no mainnet balance**. Official faucet. UI currently sends **0.0001 ETH per request**, up to **0.1 ETH / 24h** — enough to deploy. Also has a programmatic API, but it requires a CDP API key (not tried; we have no account).

2. **Superchain / Optimism faucet**  
   https://console.optimism.io/faucet/  
   (`https://app.optimism.io/faucet` redirects here.)  
   Sign in with **GitHub**. Anyone can claim **0.01 ETH / 24h** on Base Sepolia; larger amounts need onchain identity verification.

3. **Google Cloud Web3 faucet**  
   https://cloud.google.com/application/web3/faucet/base/sepolia  
   Google account + **reCAPTCHA**.

4. **thirdweb faucet**  
   https://thirdweb.com/faucets  
   Chain page: https://thirdweb.com/base-sepolia-testnet  
   Connect a wallet / social login, then request funds.

5. **Base Sepolia PoW faucet (no account)**  
   https://pow.zalalena.com/base  
   No signup. Requires **hCaptcha** and leaving the tab open to mine until the claim threshold. 1-hour cooldown after a successful claim.  
   Official pk910 Base URL `https://base-sepolia-faucet.pk910.de/` did not complete a TLS handshake when we checked; pk910’s public list (https://faucets.pk910.de/) no longer lists Base Sepolia.

6. **ethfaucet.com (BringID)**  
   https://ethfaucet.com/networks/base/base-sepolia  
   Destination can be the deployer address, but the faucet requires **BringID humanity verification** (points). A brand-new empty address is unlikely to score high enough without that browser verification.

## Skip for this empty testnet wallet

- **Alchemy** — https://www.alchemy.com/faucets/base-sepolia — requires **0.001 ETH on Ethereum mainnet** plus mainnet activity.
- **QuickNode** — https://faucet.quicknode.com/base/sepolia — official FAQ requires a **small mainnet balance** on the claiming wallet.
- **Chainstack** — https://faucet.chainstack.com/ — API key plus a mainnet-balance check (docs).

## Down or unusable when checked

- **Bware Labs** — https://bwarelabs.com/faucets/base-sepolia — HTTP 530; earlier listings also said the faucet was in maintenance / empty.
- **LearnWeb3** — https://learnweb3.io/faucets/base_sepolia/ — HTTP 503.
- **L2 Faucet (Automata)** — https://www.l2faucet.com/base — under maintenance; when live it needs WebAuthn / device attestation (browser).
- **Ethereum Ecosystem PoW** — https://www.ethereum-ecosystem.com/faucets/base-sepolia — HTTP 402 from this network.
- **CDP API** without a key — `POST https://api.cdp.coinbase.com/platform/v2/evm/faucet` returned **401 Unauthorized**.

## After a faucet pays

```bash
# confirm balance
cast balance 0x0441Fe250E71fDdC650976Dd13b041fD7abE2cc9 --rpc-url https://sepolia.base.org --ether

# deploy (does not print the key)
/workspace/afterhours/scripts/deploy-sepolia.sh
```
