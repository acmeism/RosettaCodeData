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


def digit_check(n):
    if len(str(n))<2:
        return True
    else:
        for digit in str(n):
            if not is_prime(int(digit)):
                return False
        return True


def sequence(max_n=None):
    ii = 0
    n = 0
    while True:
        ii += 1
        if is_prime(ii):
            if max_n is not None:
                if n>max_n:
                    break
            if digit_check(ii):
                n += 1
                yield ii


if __name__ == '__main__':
    generator = sequence(100)
    for index, item in zip(range(1, 16), generator):
        print(index, item)
    for index, item in zip(range(16, 100), generator):
        pass
    print(100, generator.__next__())
