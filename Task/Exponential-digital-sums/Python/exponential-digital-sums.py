""" rosettacode.org/wiki/Exponential_digital_sums """


def equal_digitalsum_exponents(num):
    """ return any equal exponential digital sums in an array """
    equalpows = []
    if num > 1:
        npow, misses = 2, 0
        while misses < num + 20:
            dsum = sum(map(int, str(num**npow)))
            if npow > 10 and dsum > 2 * num:
                break  # bail here for time contraints (see Wren example)
            if dsum == num:
                equalpows.append(npow)
            else:
                misses += 1
            npow += 1

    return equalpows


if __name__ == '__main__':

    found1, found2, multis = 0, 0, []
    print('First 25 integers that are equal to the digital sum of the number raised to some power:')
    for i in range(1, 4000):
        a = equal_digitalsum_exponents(i)
        if a:
            S_EXP = ', '.join(f'{i}^{j}' for j in a)
            found1 += 1
            if found1 <= 25:
                print(S_EXP)
            if len(a) > 2:
                found2 += 1
                multis.append(S_EXP)
                if found2 == 30:
                    print(
                        '\n\nFirst 30 that satisfy that condition in three or more ways:')
                    for grp in multis:
                        print(grp)
                if found1 >= 25 and found2 >= 30:
                    break
