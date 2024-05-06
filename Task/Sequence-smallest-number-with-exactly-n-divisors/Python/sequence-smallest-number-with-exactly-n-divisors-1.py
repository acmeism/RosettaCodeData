def divisors(n):
    divs = [1]
    for ii in range(2, int(n ** 0.5) + 3):
        if n % ii == 0:
            divs.append(ii)
            divs.append(int(n / ii))
    divs.append(n)
    return list(set(divs))


def sequence(max_n=None):
    n = 0
    while True:
        n += 1
        ii = 0
        if max_n is not None:
            if n > max_n:
                break
        while True:
            ii += 1
            if len(divisors(ii)) == n:
                yield ii
                break


if __name__ == '__main__':
    for item in sequence(15):
        print(item)
