import math

def is_prime(n: int):
    if n <= 1:
        return False

    for i in range(2, int(math.sqrt(n) + 1)):
        if n % i == 0:
            return False

    return True


def main():
    s = 0
    i = 1
    c = 0

    for p in range(2, 1000):
        if is_prime(p):
            if i % 2 != 0:
                s += p
                if is_prime(s):
                    c += 1
                    print(i, p, s)

            i += 1

    print("Odd indexed primes 2-999:", c)


if __name__ == "__main__":
    main()
