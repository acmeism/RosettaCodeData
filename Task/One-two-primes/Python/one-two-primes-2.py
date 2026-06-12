from sympy import isprime

def show_oeis36229(wanted=2000):
    ''' From Chai Wah Wu's Python code at oeis.org/A036229 '''
    for ndig in list(range(1, 21)) + list(range(100, wanted + 1, 100)):
        k, i, j = (10**ndig - 1) // 9, 2**ndig - 1, 0
        while j <= i:
            candidate = k + int(bin(j)[2:])
            if isprime(candidate):
                pstr = str(candidate)
                if ndig < 21:
                    print(f'{ndig:4}: {pstr}')
                else:
                    k = pstr.index('2')
                    print(f'{ndig:4}: (1 x {k}) {pstr[k-1:]}')

                break

            j += 1


show_oeis36229()
