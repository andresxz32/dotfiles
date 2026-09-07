#!/usr/bin/env bash
if [[ "$(uname)" == "Darwin" ]]; then
  top -l 1 -n 0 | awk '/CPU usage/ {gsub("%",""); printf "%.0f%%", $3+$5}'
else
  read -r _ u1 n1 s1 i1 _ < /proc/stat
  sleep 0.3
  read -r _ u2 n2 s2 i2 _ < /proc/stat
  total1=$((u1 + n1 + s1 + i1))
  total2=$((u2 + n2 + s2 + i2))
  idle=$((i2 - i1))
  total=$((total2 - total1))
  if [[ "$total" -gt 0 ]]; then
    echo "$(( (100 * (total - idle)) / total ))%"
  else
    echo "N/A"
  fi
fi