""" rosettacode.org/wiki/Forbidden_numbers """

def isforbidden(num):
    """ true if num is a forbidden number """
    fours, pow4 = num, 0
    while fours > 1 and fours % 4 == 0:
        fours //= 4
        pow4 += 1
    return (num // 4**pow4) % 8 == 7


f500k = list(filter(isforbidden, range(500_001)))

for idx, fbd in enumerate(f500k[:50]):
    print(f'{fbd: 4}', end='\n' if (idx + 1) % 10 == 0 else '')

for fbmax in [500, 5000, 50_000, 500_000]:
    print(
        f'\nThere are {sum(x <= fbmax for x in f500k):,} forbidden numbers <= {fbmax:,}.')
