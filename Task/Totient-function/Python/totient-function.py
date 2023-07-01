from math import gcd

def  φ(n):
    return sum(1 for k in range(1, n + 1) if gcd(n, k) == 1)

if __name__ == '__main__':
    def is_prime(n):
        return φ(n) == n - 1

    for n in range(1, 26):
        print(f" φ({n}) == {φ(n)}{', is prime' if is_prime(n)  else ''}")
    count = 0
    for n in range(1, 10_000 + 1):
        count += is_prime(n)
        if n in {100, 1000, 10_000}:
            print(f"Primes up to {n}: {count}")
