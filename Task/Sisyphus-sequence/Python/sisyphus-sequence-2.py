import primesieve

def sisyphus36():
    primes = primesieve.Iterator()
    n = 1
    p = 0
    i = 1

    while True:
        i += 1
        if n % 2:
            p = primes.next_prime()
            n = n + p
        else:
            n = n // 2

        if n == 36:
            print(f"{i:,}, {n:,}, {p:,}")
            break

if __name__ == "__main__":
    sisyphus36()
