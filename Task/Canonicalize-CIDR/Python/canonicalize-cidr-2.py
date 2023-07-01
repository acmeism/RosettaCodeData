"""Canonicalize CIDR"""
DIGITS = (24, 16, 8, 0)


def dotted_to_int(dotted: str) -> int:
    digits = [int(digit) for digit in dotted.split(".")]
    return sum(a << b for a, b in zip(digits, DIGITS))


def int_to_dotted(ip: int) -> str:
    digits = [(ip & (255 << d)) >> d for d in DIGITS]
    return ".".join(str(d) for d in digits)


def network_mask(number_of_bits: int) -> int:
    return ((1 << number_of_bits) - 1) << (32 - number_of_bits)


def canonicalize(ip: str) -> str:
    dotted, network_bits = ip.split("/")
    i = dotted_to_int(dotted)
    mask = network_mask(int(network_bits))
    return int_to_dotted(i & mask) + "/" + network_bits


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
        assert rv == expect
