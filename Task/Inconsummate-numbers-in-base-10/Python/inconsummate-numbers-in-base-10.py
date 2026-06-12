''' Rosetta code rosettacode.org/wiki/Inconsummate_numbers_in_base_10 '''


def digitalsum(num):
    ''' Return sum of digits of a number in base 10 '''
    return sum(int(d) for d in str(num))


def generate_inconsummate(max_wanted):
    ''' generate the series of inconsummate numbers up to max_wanted '''
    minimum_digitsums = [(10**i, int((10**i - 1) / (9 * i)))
                         for i in range(1, 15)]
    limit = 20 * min(p[0] for p in minimum_digitsums if p[1] > max_wanted)
    arr = [1] + [0] * (limit - 1)

    for dividend in range(1, limit):
        quo, rem = divmod(dividend, digitalsum(dividend))
        if rem == 0 and quo < limit:
            arr[quo] = 1
    for j, flag in enumerate(arr):
        if flag == 0:
            yield j


for i, n in enumerate(generate_inconsummate(100000)):
    if i < 50:
        print(f'{n:6}', end='\n' if (i + 1) % 10 == 0 else '')
    elif i == 999:
        print('\nThousandth inconsummate number:', n)
    elif i == 9999:
        print('\nTen-thousanth inconsummate number:', n)
    elif i == 99999:
        print('\nHundred-thousanth inconsummate number:', n)
        break
