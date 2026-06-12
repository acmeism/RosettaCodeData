import time
import math


class PrimeCounter:
    """Generate a list 'count' where count[n] is the number of primes less than or equal to n"""
    def __init__(self, limit):
        self.count = [1] * limit
        count = self.count
        if limit > 0:
            count[0] = 0
        if limit > 1:
            count[1] = 0
        for i in range(4, limit, 2):
            count[i] = 0
        p = 3
        while p**2 < limit:
            if count[p] != 0:
                q = p**2
                while q < limit:
                    count[q] = 0
                    q += p * 2
            p += 2
        for i, j in enumerate(count):
            if i == 0:
                continue
            count[i] += count[i - 1]

    def prime_count(self, n):
        """Get the number of primes less than or equal to n"""
        if n > 0:
            return self.count[n]
        return 0


def ramanujan_prime_upper_bound(n):
    """Calculate the largest number the nth Ramanujan number could possibly be"""
    return math.ceil(4 * n * math.log(4 * n))


def ramanujan_prime(prime_counter_in, n):
    """Generate the nth Ramanujan prime by finding the largest number 'i' where less than n primes are in the
    range i//2 and i - the Ramanujan prime is one more than i"""
    pci = prime_counter_in

    for i in range(ramanujan_prime_upper_bound(n), -1, -1):
        pi_n = pci.prime_count(i)
        pi_half_n = pci.prime_count(i // 2)

        if pi_n - pi_half_n < n:
            return i + 1
    return 0


def print_ramanujan_primes_in_range(start_number, end_number, prime_counter_in):
    """Print all Ramanujan primes between start_number (inclusive) and end_number (exclusive)"""
    for i in range(start_number, end_number):
        p = ramanujan_prime(prime_counter_in, i)
        print(f"{p : <4}", end=" ")
        if i % 10 == 0:
            print()


def solve():
    """Return the first 100 Ramanujan primes and the 1000th, 10000th & 100000th Ramanujan primes"""
    print("First 100 Ramanujan primes:\n")

    largest_number_to_calculate = ramanujan_prime_upper_bound(100000) + 1
    prime_counter = PrimeCounter(largest_number_to_calculate)

    print_ramanujan_primes_in_range(1, 101, prime_counter)
    print()

    for number in (1_000, 10_000, 100_000):
        answer = ramanujan_prime(prime_counter, number)
        print(
            f"The {number : >6}th ramanujan prime is {answer : >7}"
        )


start = time.perf_counter()
solve()
end = time.perf_counter()
time_taken_ms = int((end - start) * 1000)
print(f"\nElapsed time: {time_taken_ms}ms")
