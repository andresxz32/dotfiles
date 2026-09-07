#!/usr/bin/env bash
if [[ "$(uname)" == "Darwin" ]]; then
  ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "N/A"
elif grep -qi microsoft /proc/version 2>/dev/null; then
  # Inside WSL: query the Windows host's actual Ethernet adapter, not
  # the WSL virtual network interface (which is a separate, internal IP)
  ip=$(powershell.exe -NoProfile -Command "(Get-NetIPAddress -InterfaceAlias 'Ethernet*' -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -First 1).IPAddress" 2>/dev/null | tr -d '\r')
  echo "${ip:-N/A}"
else
  hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A"
fi