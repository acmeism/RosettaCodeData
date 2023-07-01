import ipaddress

def canonicalize(address: str) -> str:
    return str(ipaddress.ip_network(address, strict=False))

TEST_CASES = [
    ("36.18.154.103/12", "36.16.0.0/12"),
    ("62.62.197.11/29", "62.62.197.8/29"),
    ("67.137.119.181/4", "64.0.0.0/4"),
    ("161.214.74.21/24", "161.214.74.0/24"),
    ("184.232.176.184/18", "184.232.128.0/18"),
]

if __name__ == "__main__":
    for ip, expect in TEST_CASES:
        rv = canonicalize(ip)
        print(f"{ip:<18} -> {rv}")
        assert rv == expect, expect
