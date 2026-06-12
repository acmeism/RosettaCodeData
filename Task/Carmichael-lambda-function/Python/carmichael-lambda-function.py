from sympy import reduced_totient

def iterated_to_one(i):
    """ return k for the k-fold iterated lambda function where k is the first time iteration reaches 1 """
    k = 0
    while i > 1:
        i = reduced_totient(i)
        k += 1
    return k


if __name__ == "__main__":
    print("Listing of (n, lambda(n), k for iteration to 1) for integers from 1 to 25:")
    for i in range(1, 26):
        lam = reduced_totient(i)
        k = iterated_to_one(i)
        print(f'({i}, {lam}, {k})', end = '\n' if i % 5 == 0 else '  ')

    UP_TO = 20
    MAX_TO_TEST = 100_000_000_000
    FIRSTS = [0] * (UP_TO + 1)
    FIRSTS[0] = 1

    print('\nIterations to 1     n   lambda(n)\n==================================')
    print('   0                1          1')
    for i in range(2, MAX_TO_TEST):
        n = iterated_to_one(i)
        if 0 < n <= UP_TO and FIRSTS[n] == 0:
            FIRSTS[n] = i
            j = 0 if n < 1 else int(reduced_totient(i))
            print(f"{n:>4}{i:>17}{j:>11}")
            if n >= UP_TO:
                break


