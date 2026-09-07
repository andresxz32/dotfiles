#!/usr/bin/env bash
if [[ "$(uname)" == "Darwin" ]]; then
  top -l 1 -n 0 | awk '/CPU usage/ {gsub("%",""); printf "%.0f%%", $3+$5}'
elif grep -qi microsoft /proc/version 2>/dev/null; then
  # Inside WSL: query the actual Windows host, not the WSL VM's own usage
  val=$(powershell.exe -NoProfile -Command "(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue" 2>/dev/null | tr -d '\r')
  printf "%.0f%%" "${val:-0}"
else
  read -r _ u1 n1 s1 i1 _ < /proc/stat
  sleep 0.3
  read -r _ u2 n2 s2 i2 _ < /proc/stat
  total1=$((u1 + n1 + s1 + i1)); total2=$((u2 + n2 + s2 + i2))
  idle=$((i2 - i1)); total=$((total2 - total1))
  if [[ "$total" -gt 0 ]]; then echo "$(( (100 * (total - idle)) / total ))%"; else echo "N/A"; fi
fi