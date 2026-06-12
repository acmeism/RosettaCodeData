2 things:
"""for the Fibonacci sequence: an even number is following after 2 odd numbers. Eliminate time to check whether it is prime or not because even numbers are not primes.
for prime numbers: it becomes bigger and bigger. The original algorithm will be slow for super big number. In this case, I use Miller Rabin primality test.

P/S: I am not surprised. It is fast but still cannot compare to other languages such as C++ or Rust or .... After all, Python is still slow :P"""

def miller_rabin(n, k=5):
    if n < 2:
        return False
    for p in [2, 3, 5, 7, 11]:
        if n < p * p:
            return True
        if n % p == 0:
            return False
    r, s = 0, n - 1
    while s % 2 == 0:
        r += 1
        s //= 2
    for _ in range(k):
        a = random.randint(2, n - 1)
        x = pow(a, s, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(r - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True


def format_large_number(n):
    s = str(n)
    if len(s) > 50:
        return "%s...%s (Total %d digits)" % (s[:10], s[-10:], len(s))
    return s


def prime_fibonacci(n):
    a, b = 1, 1
    fibn = 2
    odd_count = 0
    start = time()

    while n > 0:
        if a == 2 or (a % 2 != 0 and miller_rabin(a)):
            print("fib(%d): %s (%s s)" % (fibn - 1, format_large_number(a), time() - start))
            n -= 1
            if a % 2 != 0:
                odd_count += 1
            else:
                odd_count = 0
        else:
            odd_count = 0

        if odd_count == 2:
            a, b = b, a + b
            fibn += 1
            odd_count = 1
            continue

        a, b = b, a + b
        fibn += 1


prime_fibonacci(26)

