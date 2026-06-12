from sympy import isprime, factorial

def next_prime(n: int):
    t = n

    while True:
        t += 1

        if isprime(t):
            return t, t - n

def main():
    print("Least positive m such that n! + m is prime; first 50:")

    for i in range(0, 50):
        n = factorial(i)
        num, m = next_prime(n)

        if i % 10 == 0 and i != 0:
            print()

        print("%3d" % m, end=' ')

    t = 1000
    limit = 10_000
    i = 50

    print("\n")

    while t <= limit:
        n = factorial(i)
        num, m = next_prime(n)

        if m > t:
            while True:
                print(f"First m > {t} is {m} at position {i}")
                t += 1000

                if m <= t:
                    break

        i += 1

if __name__ == "__main__":
    main()
