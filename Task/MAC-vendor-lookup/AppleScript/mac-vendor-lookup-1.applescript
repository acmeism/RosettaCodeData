set apiRoot to "https://api.macvendors.com"
set macList to {"88:53:2E:67:07:BE", "D4:F4:6F:C9:EF:8D", ¬
                "FC:FB:FB:01:FA:21", "4c:72:b9:56:fe:bc", "00-14-22-01-23-45"}

on lookupVendor(macAddr)
  global apiRoot
  return do shell script "curl " & apiRoot & "/" & macAddr
end lookupVendor

set table to { lookupVendor(first item of macList) }
repeat with burger in macList's items 2 thru -1
    delay 1.5
    set end of table to lookupVendor(burger)
end repeat

set text item delimiters to linefeed
return table as string
