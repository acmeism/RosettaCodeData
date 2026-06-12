def to_digits(n: int):
    digits = []

    while n > 0:
        digits.append(n % 10)
        n //= 10

    return digits

def is_permuted_num(n: int):
    digits = to_digits(n)
    res = True

    for i in range(2, 7):
        d = to_digits(i * n)
        res = res & (set(d) == set(digits) and len(d) == len(digits))

        if not res:
            break

    return res

def main():
    n = 123

    while not is_permuted_num(n):
        n += 1

    for i in range(1, 7):
        print(n, "*", i, "=", n * i)

if __name__ == '__main__':
    main()
