set macList=(88:53:2E:67:07:BE D4:F4:6F:C9:EF:8D FC:FB:FB:01:FA:21 \
             4c:72:b9:56:fe:bc 00-14-22-01-23-45)

alias lookup curl -s "http://api.macvendors.com/!":1 "&&" echo

lookup "$macList[1]"
foreach burger ($macList[2-]:q)
  sleep 2
  lookup "$burger"
end
