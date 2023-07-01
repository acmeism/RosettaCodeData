import mpmath as mp

with mp.workdps(72):

    def integer_term(n):
        p = 532 * n * n + 126 * n + 9
        return (p * 2**5 * mp.factorial(6 * n)) / (3 * mp.factorial(n)**6)

    def exponent_term(n):
        return -(mp.mpf("6.0") * n + 3)

    def nthterm(n):
        return integer_term(n) * mp.mpf("10.0")**exponent_term(n)


    for n in range(10):
        print("Term ", n, '  ', int(integer_term(n)))


    def almkvist_guillera(floatprecision):
        summed, nextadd = mp.mpf('0.0'), mp.mpf('0.0')
        for n in range(100000000):
            nextadd = summed + nthterm(n)
            if abs(nextadd - summed) < 10.0**(-floatprecision):
                break

            summed = nextadd

        return nextadd


    print('\nπ to 70 digits is ', end='')
    mp.nprint(mp.mpf(1.0 / mp.sqrt(almkvist_guillera(70))), 71)
    print('mpmath π is       ', end='')
    mp.nprint(mp.pi, 71)
