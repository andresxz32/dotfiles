#!/usr/bin/env bash
if [[ "$(uname)" == "Darwin" ]]; then
  top -l 1 -s 0 | awk '/PhysMem/ {
    gsub("[A-Za-z,]", "", $2); used=$2; gsub("[A-Za-z,]", "", $6); unused=$6;
    total = used + unused; if (total > 0) { printf "%.0f%%", (used/total)*100 } else { print "N/A" }
  }'
elif grep -qi microsoft /proc/version 2>/dev/null; then
  powershell.exe -NoProfile -Command "\$os = Get-CimInstance Win32_OperatingSystem; [math]::Round((\$os.TotalVisibleMemorySize - \$os.FreePhysicalMemory) / \$os.TotalVisibleMemorySize * 100)" 2>/dev/null | tr -d '\r' | awk '{printf "%s%%", $1}'
else
  free -m | awk 'NR==2 { printf "%.0f%%", ($3/$2)*100 }'
fi