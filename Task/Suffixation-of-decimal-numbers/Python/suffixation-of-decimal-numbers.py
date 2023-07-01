import math
import os


def suffize(num, digits=None, base=10):
    suffixes = ['', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y', 'X', 'W', 'V', 'U', 'googol']

    exponent_distance = 10 if base == 2 else 3
    num = num.strip().replace(',', '')
    num_sign = num[0] if num[0] in '+-' else ''

    num = abs(float(num))

    if base == 10 and num >= 1e100:
        suffix_index = 13
        num /= 1e100
    elif num > 1:
        magnitude = math.floor(math.log(num, base))
        suffix_index = min(math.floor(magnitude / exponent_distance), 12)
        num /= base ** (exponent_distance * suffix_index)
    else:
        suffix_index = 0

    if digits is not None:
        num_str = f'{num:.{digits}f}'
    else:
        num_str = f'{num:.3f}'.strip('0').strip('.')

    return num_sign + num_str + suffixes[suffix_index] + ('i' if base == 2 else '')


tests = [('87,654,321',),
         ('-998,877,665,544,332,211,000', 3),
         ('+112,233', 0),
         ('16,777,216', 1),
         ('456,789,100,000,000', 2),
         ('456,789,100,000,000', 2, 10),
         ('456,789,100,000,000', 5, 2),
         ('456,789,100,000.000e+00', 0, 10),
         ('+16777216', None, 2),
         ('1.2e101',)]

for test in tests:
    print(' '.join(str(i) for i in test) + ' : ' + suffize(*test))
