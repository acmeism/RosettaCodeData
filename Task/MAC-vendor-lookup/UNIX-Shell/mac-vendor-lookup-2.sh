set -- 88:53:2E:67:07:BE D4:F4:6F:C9:EF:8D FC:FB:FB:01:FA:21 \
       4c:72:b9:56:fe:bc 00-14-22-01-23-45

lookup() {
  curl -s "http://api.macvendors.com/$1" && echo
}

lookup "$1"
shift
for burger; do
  sleep 2
  curl -s "http://api.macvendors.com/$burger" && echo
done
