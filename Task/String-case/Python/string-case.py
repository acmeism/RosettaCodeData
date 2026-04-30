import string

EXAMPLE_STRINGS = [
    "alphaBETA",
    "ação",
    "o'hare O'HARE o’hare don't",
    "Stroßbùrri",
    "ĥåçýджк",
    "Ǆǈǌ",
]

for s in EXAMPLE_STRINGS:
    print(f"original        : {s}")
    print(f"upper           : {s.upper()}")
    print(f"lower           : {s.lower()}")
    print(f"capitalize      : {s.capitalize()}")
    print(f"title           : {s.title()}")
    print(f"swapcase        : {s.swapcase()}")
    print(f"casefold        : {s.casefold()}")
    print(f"string.capwords : {string.capwords(s, sep=None)}\n")
