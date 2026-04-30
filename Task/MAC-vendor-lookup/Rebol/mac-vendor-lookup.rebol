system/options/quiet: true
foreach mac [
    "88:53:2E:67:07:BE"
    "FC:FB:FB:01:FA:21"
    "D4:F4:6F:C9:EF:8D"
][
    res: read join http://api.macvendors.com/ mac
    print [mac res]
]
