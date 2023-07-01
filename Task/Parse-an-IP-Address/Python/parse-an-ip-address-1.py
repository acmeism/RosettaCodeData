from ipaddress import ip_address
from urllib.parse import urlparse

tests = [
    "127.0.0.1",
    "127.0.0.1:80",
    "::1",
    "[::1]:80",
    "::192.168.0.1",
    "2605:2700:0:3::4713:93e3",
    "[2605:2700:0:3::4713:93e3]:80" ]

def parse_ip_port(netloc):
    try:
        ip = ip_address(netloc)
        port = None
    except ValueError:
        parsed = urlparse('//{}'.format(netloc))
        ip = ip_address(parsed.hostname)
        port = parsed.port
    return ip, port

for address in tests:
    ip, port = parse_ip_port(address)
    hex_ip = {4:'{:08X}', 6:'{:032X}'}[ip.version].format(int(ip))
    print("{:39s}  {:>32s}  IPv{}  port={}".format(
        str(ip), hex_ip, ip.version, port ))
