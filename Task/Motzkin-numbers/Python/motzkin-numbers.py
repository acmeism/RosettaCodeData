""" rosettacode.org/wiki/Motzkin_numbers """

from sympy import isprime


def motzkin(num_wanted):
    """ Return list of the first N Motzkin numbers """
    mot = [1] * (num_wanted + 1)
    for i in range(2, num_wanted + 1):
        mot[i] = (mot[i-1]*(2*i+1) + mot[i-2]*(3*i-3)) // (i + 2)
    return mot


def print_motzkin_table(N=41):
    """ Print table of first N Motzkin numbers, and note if prime """
    print(
        " n          M[n]             Prime?\n-----------------------------------")
    for i, e in enumerate(motzkin(N)):
        print(f'{i : 3}{e : 24,}', isprime(e))


print_motzkin_table()
