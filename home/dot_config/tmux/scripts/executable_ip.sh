#!/usr/bin/env bash
if [[ "$(uname)" == "Darwin" ]]; then
  ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "N/A"
else
  hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A"
fi