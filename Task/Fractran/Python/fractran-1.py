from fractions import Fraction

def fractran(n, fstring='17 / 91, 78 / 85, 19 / 51, 23 / 38, 29 / 33,'
                        '77 / 29, 95 / 23, 77 / 19, 1 / 17, 11 / 13,'
                        '13 / 11, 15 / 14, 15 / 2, 55 / 1'):
    flist = [Fraction(f) for f in fstring.replace(' ', '').split(',')]

    n = Fraction(n)
    while True:
        yield n.numerator
        for f in flist:
            if (n * f).denominator == 1:
                break
        else:
            break
        n *= f

if __name__ == '__main__':
    n, m = 2, 15
    print('First %i members of fractran(%i):\n  ' % (m, n) +
          ', '.join(str(f) for f,i in zip(fractran(n), range(m))))
