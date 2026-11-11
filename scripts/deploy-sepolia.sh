#!/usr/bin/env bash
# Deploy AfterHoursBoard to Base Sepolia. Never echoes the private key.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ENV_FILE="$ROOT/.env.deployer"
RPC="${BASE_SEPOLIA_RPC:-https://sepolia.base.org}"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE" >&2
  exit 1
fi

# Load without printing values
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if [[ -z "${PRIVATE_KEY:-}" ]]; then
  echo "PRIVATE_KEY is not set in the env file" >&2
  exit 1
fi

if [[ -z "${DEPLOYER_ADDRESS:-}" ]]; then echo "DEPLOYER_ADDRESS not set" >&2; exit 1; fi
# forge script needs an explicit signer. The key is passed from the env var and never printed.
DEPLOY_KEY="$PRIVATE_KEY"
unset PRIVATE_KEY

cd "$ROOT/contracts"
# Print only public info
echo "Deployer: ${DEPLOYER_ADDRESS:-unknown}"
echo "RPC: $RPC"
echo "Chain: Base Sepolia (84532)"

forge script script/Deploy.s.sol:DeployScript \
  --rpc-url "$RPC" \
  --broadcast \
  --private-key "$DEPLOY_KEY" \
  --sender "${DEPLOYER_ADDRESS}" \
  --chain 84532

# Try free verification (Sourcify, then Blockscout). Ignore failures.
if [[ -f broadcast/Deploy.s.sol/84532/run-latest.json ]]; then
  ADDR=$(python3 - << 'PY'
import json
from pathlib import Path
data = json.loads(Path("broadcast/Deploy.s.sol/84532/run-latest.json").read_text())
txs = data.get("transactions") or []
for t in txs:
    if t.get("contractName") == "AfterHoursBoard" and t.get("contractAddress"):
        print(t["contractAddress"])
        break
PY
)
  if [[ -n "${ADDR:-}" ]]; then
    echo "Contract: $ADDR"
    echo "Explorer: https://sepolia.basescan.org/address/$ADDR"
    echo "Blockscout: https://base-sepolia.blockscout.com/address/$ADDR"
    forge verify-contract "$ADDR" src/AfterHoursBoard.sol:AfterHoursBoard \
      --chain 84532 --verifier sourcify --watch || true
    forge verify-contract "$ADDR" src/AfterHoursBoard.sol:AfterHoursBoard \
      --chain 84532 \
      --verifier blockscout \
      --verifier-url https://base-sepolia.blockscout.com/api/ || true
  fi
fi
