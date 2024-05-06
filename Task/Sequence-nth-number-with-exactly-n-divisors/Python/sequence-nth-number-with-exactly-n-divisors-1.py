def divisors(n):
    divs = [1]
    for ii in range(2, int(n ** 0.5) + 3):
        if n % ii == 0:
            divs.append(ii)
            divs.append(int(n / ii))
    divs.append(n)
    return list(set(divs))


def is_prime(n):
    return len(divisors(n)) == 2


def primes():
    ii = 1
    while True:
        ii += 1
        if is_prime(ii):
            yield ii


def prime(n):
    generator = primes()
    for ii in range(n - 1):
        generator.__next__()
    return generator.__next__()


def n_divisors(n):
    ii = 0
    while True:
        ii += 1
        if len(divisors(ii)) == n:
            yield ii


def sequence(max_n=None):
    if max_n is not None:
        for ii in range(1, max_n + 1):
            if is_prime(ii):
                yield prime(ii) ** (ii - 1)
            else:
                generator = n_divisors(ii)
                for jj, out in zip(range(ii - 1), generator):
                    pass
                yield generator.__next__()
    else:
        ii = 1
        while True:
            ii += 1
            if is_prime(ii):
                yield prime(ii) ** (ii - 1)
            else:
                generator = n_divisors(ii)
                for jj, out in zip(range(ii - 1), generator):
                    pass
                yield generator.__next__()


if __name__ == '__main__':
    for item in sequence(15):
        print(item)
