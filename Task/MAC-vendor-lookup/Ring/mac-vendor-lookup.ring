# Project: MAC Vendor Lookup

load "stdlib.ring"
macs = ["FC-A1-3E","FC:FB:FB:01:FA:21","88:53:2E:67:07:BE","D4:F4:6F:C9:EF:8D"]
for mac = 1 to len(macs)
     lookupvendor(macs[mac])
next

func lookupvendor(mac)
       url = download("api.macvendors.com/" + mac)
       see url + nl
