from fractions import Fraction

def map_range(a, b, s):
    (a1, a2), (b1, b2) = a, b
    return b1 + ((s - a1) * (b2 - b1) / (a2 - a1))

for s in range(11):
    print(f"{s:2g} maps to {map_range((0, 10), (-1, 0), s):g}")

print()

# Because of Python's strict, dynamic typing rules for numbers, the same
# function can give answers as fractions.

for s in range(11):
    print(f"{s:2g} maps to {map_range((0, 10), (-1, 0), Fraction(s))}")
