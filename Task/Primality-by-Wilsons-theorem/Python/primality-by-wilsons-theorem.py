from math import factorial

def is_wprime(n):
    return n == 2 or (
        n > 1
        and n % 2 != 0
        and (factorial(n - 1) + 1) % n == 0
    )

if __name__ == '__main__':
    c = int(input('Enter upper limit: '))
    print(f'Primes under {c}:')
    print([n for n in range(c) if is_wprime(n)])
