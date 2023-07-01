"""

Python implementation of
http://rosettacode.org/wiki/Chernick%27s_Carmichael_numbers

"""

# use sympy for prime test

from sympy import isprime

# based on C version

def primality_pretest(k):
    if not (k % 3) or not (k % 5) or not (k % 7) or not (k % 11) or not(k % 13) or not (k % 17) or not (k % 19) or not (k % 23):
        return (k <= 23)

    return True

def is_chernick(n, m):

    t = 9 * m

    if not primality_pretest(6 * m + 1):
        return False

    if not primality_pretest(12 * m + 1):
        return False

    for i in range(1,n-1):
        if not primality_pretest((t << i) + 1):
            return False

    if not isprime(6 * m + 1):
        return False

    if not isprime(12 * m + 1):
        return False

    for i in range(1,n - 1):
        if not isprime((t << i) + 1):
            return False

    return True

for n in range(3,10):

    if n > 4:
        multiplier = 1 << (n - 4)
    else:
        multiplier = 1

    if n > 5:
        multiplier *= 5


    k = 1

    while True:
        m = k * multiplier

        if is_chernick(n, m):
            print("a("+str(n)+") has m = "+str(m))
            break

        k += 1
