# Hosting

**Live: https://afterhours-base.netlify.app** (Netlify project `afterhours-base`, Builds' account aladebuilds@gmail.com). Deployed 11 Nov 2026, 17:03 WAT; updated 17:06 WAT.

- Full Next.js app incl. server routes: `/api/snapshot`, `/api/agent` (verified 200 with live data), `/api/agent/run` (dry-run on Netlify), `/api/stats` (onchain traction).
- **No secrets uploaded.** The site is read-only; `AGENT_PRIVATE_KEY` stays on the box and `scripts/agent-loop.sh` posts calls every 30 min. No Netlify env vars are required (contract address and the agent Builder Code `bc_tdrm1ha8` are in code; public RPC defaults). Optional: set `NEXT_PUBLIC_BASE_BUILDER_CODE` on Netlify after registering a project on [dashboard.base.org](https://dashboard.base.org) — it is a public identifier, not a secret.
- Visitor access: Netlify's account default was "Netlify login required" (HTTP 401). It was turned off (`sso_login: false`) so the site is public.
- Redeploy from `web/`: move `.env.local` aside first so the testnet key never gets bundled, then `npx netlify-cli deploy --prod`.

---

# Original no-account checks (checked 11 Nov 2026, ~17:00 WAT)

This box's network only allows normal HTTP(S) out. Results:

| Option | Account needed? | Result from this box |
| --- | --- | --- |
| Cloudflare quick tunnel (`cloudflared --url`) | No | **Blocked.** Needs outbound port 7844 (QUIC and HTTP/2 both failed). |
| localhost.run / Pinggy (SSH `-R`) | No | **Blocked.** SSH connection closed by the network proxy. |
| localtunnel (`loca.lt`) | No | URL issued, but returns **502**: raw TCP back-channel blocked. |
| Netlify `deploy --allow-anonymous` | No (to deploy) | **Works for static files only.** Lives 60 min, password `My-Drop-Site`, deleted unless claimed. Server routes (the agent API) are refused without login. |
| Netlify full app (SSR + agent API) | **Yes — free Netlify account** (email or Google sign-up; GitHub not required) | Ready. `netlify login --request` gives an authorise link; once Builds approves it, the box can deploy. |
| Vercel CLI | Yes — Vercel account + token | Not tried (account needed). |
| surge.sh | Yes — email + password via CLI | Not tried (would create an account). Static only. |
| IPFS pinning (Pinata, web3.storage, 4EVERLAND) | Yes | Not tried. Static only. |

## Recommended path (one step for Builds, ~3 minutes on a phone)

1. Sign up free at https://app.netlify.com/signup with email or Google (no GitHub needed).
2. Open the authorise link the agent gives you (created with `netlify login --request`; tickets expire, so ask for a fresh one) and press **Authorize**.
3. The agent then runs from `web/`:

```bash
npx netlify-cli deploy --create-site afterhours-base --prod
```

Netlify builds the Next.js app with its built-in Next runtime (`web/netlify.toml`). Keep the public site **read-only** (no `AGENT_PRIVATE_KEY` there); the agent keeps posting from the box with `scripts/agent-loop.sh`. If you want the hosted site to post too, add `AGENT_PRIVATE_KEY` (testnet) and `AGENT_RUN_SECRET` as Netlify env vars and hit `/api/agent/run` from a scheduled function or any free cron pinger.
