#!/usr/bin/env bash
# Fetch live player positions for Lands of Jail Server 133
# Requires: curl, jq
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DIR/.env"

TMP="$(mktemp)"
STEP=64
SIZE=4096

for ((X=0; X<SIZE; X+=STEP)); do
  for ((Y=0; Y<SIZE; Y+=STEP)); do
    curl -s "${LOJ_BASE}?serverId=$SERVER_ID&x0=$X&y0=$Y&x1=$((X+STEP-1))&y1=$((Y+STEP-1))"       -H "Authorization: Bearer $LOJ_JWT" >> "$TMP"
  done
done

jq -s '
  reduce .[] as $c ([]; . + $c) |
  {type:"FeatureCollection",
   features: map({
     type:"Feature",
     id:.uid,
     geometry:{type:"Point",coordinates:[.x, (.y*-1)]},
     properties:{nick:.nick,level:.level,lastSeen:(now|todateiso8601)}
   })
  }' "$TMP" > "$DIR/web/snapshot.json"
