#!/bin/bash

# $(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10)

token=<your_telegram_token>
chat_id=<yout_chat_id>

cpuuse=$(mpstat 1 5 | awk 'END{print 100-$NF}')
if [ "$cpuuse" -ge 15 ]; then

  #get cpu info and 20 process that consuming cpu the most using top  
  test="CPU current usage for $(hostname) is: $cpuuse%
  +------------------------------------------------------------------+
  Top 20 processes which consuming high CPU
  +------------------------------------------------------------------+
  $(top -bn1 | head -20)"

  #also get cpu info and 7 process that consuming cpu the most using ps
  test2="CPU current usage for $(hostname) is: $cpuuse%
  +------------------------------------------------------------------+
  Top 7 Processes which consuming high CPU using the ps command
  +------------------------------------------------------------------+
  <pre><code class=language-bash>$(ps -eo pcpu,pid,args | sort -k 1 -r | head -7)</code></pre>"

  curl -G \
  'https://api.telegram.org/bot'$token'/sendMessage' \
  -d chat_id=$chat_id \
  --data-urlencode "text=$test2" \
  -d parse_mode=html
else
echo "Server CPU usage is in under threshold"
  fi