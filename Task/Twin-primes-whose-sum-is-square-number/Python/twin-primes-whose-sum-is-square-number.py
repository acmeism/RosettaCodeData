import math

def sieve_of_eratosthenes(limit):
    """Generate list of primes up to limit using Sieve of Eratosthenes."""
    sieve = [True] * (limit + 1)
    sieve[0] = sieve[1] = False
    for num in range(2, int(math.isqrt(limit)) + 1):
        if sieve[num]:
            sieve[num*num : limit+1 : num] = [False]*len(range(num*num, limit+1, num))
    primes = [num for num, is_prime in enumerate(sieve) if is_prime]
    return primes

def is_perfect_square(n):
    """Check if a number is a perfect square."""
    root = int(math.isqrt(n))
    return root * root == n

def find_twin_primes_with_square_sum(limit):
    """Find twin primes under limit whose sum is a perfect square."""
    primes = sieve_of_eratosthenes(limit)
    twin_primes_with_square_sum = []
    for i in range(len(primes) - 1):
        p1 = primes[i]
        p2 = primes[i + 1]
        if p2 - p1 == 2:
            s = p1 + p2
            if is_perfect_square(s):
                twin_primes_with_square_sum.append((p1, p2))
    return twin_primes_with_square_sum

if __name__ == "__main__":
    limit = 10_000_000
    result = find_twin_primes_with_square_sum(limit)
    for pair in result:
        square = math.isqrt(pair[0] + pair[1])
        print(f"Twin primes: {pair}, Sum: {pair[0] + pair[1]} = {square}^2")
