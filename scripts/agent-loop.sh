#!/usr/bin/env bash
# Run the AfterHours Agent every N minutes against a running web server (default http://localhost:3000).
# Reads AGENT_RUN_SECRET from web/.env.local without printing it. Stop with: pkill -f agent-loop.sh
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${AGENT_URL:-http://localhost:3000}"
EVERY_MIN="${AGENT_EVERY_MIN:-30}"
SECRET="$(grep -E '^AGENT_RUN_SECRET=' "$ROOT/web/.env.local" | cut -d= -f2-)"
LOG="${AGENT_LOG:-/tmp/afterhours-agent.log}"
while true; do
  ts="$(date '+%Y-%m-%d %H:%M %Z')"
  out="$(curl -s -m 120 -X POST "$URL/api/agent/run" -H "x-agent-secret: $SECRET" | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin); print(json.dumps(d.get("results", d.get("error"))))
except Exception as e: print("bad response", e)')"
  echo "$ts $out" >> "$LOG"
  sleep $((EVERY_MIN * 60))
done
