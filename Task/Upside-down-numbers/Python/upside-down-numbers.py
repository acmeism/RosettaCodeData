""" rosettacode.org task Upside-down_numbers """


def gen_upside_down_number():
    """ generate upside-down numbers (OEIS A299539) """
    wrappings = [[1, 9], [2, 8], [3, 7], [4, 6],
                 [5, 5], [6, 4], [7, 3], [8, 2], [9, 1]]
    evens = [19, 28, 37, 46, 55, 64, 73, 82, 91]
    odds = [5]
    odd_index, even_index = 0, 0
    ndigits = 1
    while True:
        if ndigits % 2 == 1:
            if len(odds) > odd_index:
                yield odds[odd_index]
                odd_index += 1
            else:
                # build next odds, but switch to evens
                odds = [hi * 10**(ndigits + 1) + 10 *
                        i + lo for hi, lo in wrappings for i in odds]
                ndigits += 1
                odd_index = 0
        else:
            if len(evens) > even_index:
                yield evens[even_index]
                even_index += 1
            else:
                # build next evens, but switch to odds
                evens = [hi * 10**(ndigits + 1) + 10 *
                         i + lo for hi, lo in wrappings for i in evens]
                ndigits += 1
                even_index = 0     even_index = 0


print('First fifty upside-downs:')
for (udcount, udnumber) in enumerate(gen_upside_down_number()):
    if udcount < 50:
        print(f'{udnumber : 5}', end='\n' if (udcount + 1) % 10 == 0 else '')
    elif udcount == 499:
        print(f'\nFive hundredth: {udnumber: ,}')
    elif udcount == 4999:
        print(f'\nFive thousandth: {udnumber: ,}')
    elif udcount == 49_999:
        print(f'\nFifty thousandth: {udnumber: ,}')
    elif udcount == 499_999:
        print(f'\nFive hundred thousandth: {udnumber: ,}')
    elif udcount == 4_999_999:
        print(f'\nFive millionth: {udnumber: ,}')
        break
