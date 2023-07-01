import requests

for addr in ['88:53:2E:67:07:BE', 'FC:FB:FB:01:FA:21',
        'D4:F4:6F:C9:EF:8D', '23:45:67']:
    vendor = requests.get('http://api.macvendors.com/' + addr).text
    print(addr, vendor)
