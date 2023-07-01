""" rosettacode.orgwiki/Magnanimous_numbers """

from sympy import isprime


def is_magnanimous(num):
    """ True is num is a magnanimous number """
    if num < 10:
        return True
    for i in range(1, len(str(num))):
        quo, rem = divmod(num, 10**i)
        if not isprime(quo + rem):
            return False
    return True


if __name__ == '__main__':

    K, MCOUNT = 0, 0
    print('First 45 magnanimous numbers:')
    while MCOUNT < 400:
        if is_magnanimous(K):
            if MCOUNT < 45:
                print(f'{K:4d}', end='\n' if (MCOUNT + 1) % 15 == 0 else '')
            elif MCOUNT == 239:
                print('\n241st through 250th magnanimous numbers:')
            elif 239 < MCOUNT < 250:
                print(f'{K:6d}', end='')
            elif MCOUNT == 389:
                print('\n\n391st through 400th magnanimous numbers:')
            elif 389 < MCOUNT < 400:
                print(f'{K:7d}', end='')
            MCOUNT += 1
        K += 1
