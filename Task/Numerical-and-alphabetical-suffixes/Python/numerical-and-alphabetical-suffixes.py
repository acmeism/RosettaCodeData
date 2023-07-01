from functools import reduce
from operator import mul
from decimal import *

getcontext().prec = MAX_PREC

def expand(num):
    suffixes = [
        #     (name, min_abbreviation_length, base, exponent)
        ('greatgross', 7, 12, 3),
        ('gross', 2, 12, 2),
        ('dozens', 3, 12, 1),
        ('pairs', 4, 2, 1),
        ('scores', 3, 20, 1),
        ('googols', 6, 10, 100),
        ('ki', 2, 2, 10),
        ('mi', 2, 2, 20),
        ('gi', 2, 2, 30),
        ('ti', 2, 2, 40),
        ('pi', 2, 2, 50),
        ('ei', 2, 2, 60),
        ('zi', 2, 2, 70),
        ('yi', 2, 2, 80),
        ('xi', 2, 2, 90),
        ('wi', 2, 2, 100),
        ('vi', 2, 2, 110),
        ('ui', 2, 2, 120),
        ('k', 1, 10, 3),
        ('m', 1, 10, 6),
        ('g', 1, 10, 9),
        ('t', 1, 10, 12),
        ('p', 1, 10, 15),
        ('e', 1, 10, 18),
        ('z', 1, 10, 21),
        ('y', 1, 10, 24),
        ('x', 1, 10, 27),
        ('w', 1, 10, 30)
    ]

    num = num.replace(',', '').strip().lower()

    if num[-1].isdigit():
        return float(num)

    for i, char in enumerate(reversed(num)):
        if char.isdigit():
            input_suffix = num[-i:]
            num = Decimal(num[:-i])
            break

    if input_suffix[0] == '!':
        return reduce(mul, range(int(num), 0, -len(input_suffix)))

    while len(input_suffix) > 0:
        for suffix, min_abbrev, base, power in suffixes:
            if input_suffix[:min_abbrev] == suffix[:min_abbrev]:
                for i in range(min_abbrev, len(input_suffix) + 1):
                    if input_suffix[:i+1] != suffix[:i+1]:
                        num *= base ** power
                        input_suffix = input_suffix[i:]
                        break
                break

    return num


test = "2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre\n\
        1,567      +1.567k    0.1567e-2m\n\
        25.123kK    25.123m   2.5123e-00002G\n\
        25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei\n\
        -.25123e-34Vikki      2e-77gooGols\n\
        9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!"

for test_line in test.split("\n"):
    test_cases = test_line.split()
    print("Input:", ' '.join(test_cases))
    print("Output:", ' '.join(format(result, ',f').strip('0').strip('.') for result in map(expand, test_cases)))
