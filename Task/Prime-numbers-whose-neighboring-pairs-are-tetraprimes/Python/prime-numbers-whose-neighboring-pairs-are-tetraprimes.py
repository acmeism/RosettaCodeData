import math
import time
from collections import defaultdict

def sieve_of_eratosthenes(limit):
    """Generate all primes up to the given limit using the Sieve of Eratosthenes."""
    sieve = [True] * (limit + 1)
    sieve[0] = sieve[1] = False

    for i in range(2, int(math.sqrt(limit)) + 1):
        if sieve[i]:
            for j in range(i*i, limit + 1, i):
                sieve[j] = False

    return [i for i in range(limit + 1) if sieve[i]]

def prime_factorization(n, primes_list, primes_set):
    """Return the prime factorization of n as a list of primes."""
    if n in primes_set:
        return [n]

    factors = []
    for p in primes_list:
        if p * p > n:  # No need to check beyond sqrt(n)
            break

        while n % p == 0:
            factors.append(p)
            n //= p

        if n == 1:
            break

    # If n is not fully factorized yet, it must be a prime itself
    if n > 1:
        factors.append(n)

    return factors

def is_tetraprime(n, primes_list, primes_set, prime_factors_cache):
    """Check if a number is a tetraprime (product of exactly 4 distinct primes)."""
    if n in prime_factors_cache:
        factors = prime_factors_cache[n]
    else:
        factors = prime_factorization(n, primes_list, primes_set)
        prime_factors_cache[n] = factors

    # A tetraprime must have exactly 4 distinct prime factors
    distinct_factors = set(factors)
    return len(distinct_factors) == 4 and len(factors) == 4

def find_primes_with_tetraprime_neighbors(primes, limit, direction="preceding"):
    """Find primes whose neighboring pairs are both tetraprimes."""
    result = []
    primes_set = set(primes)
    prime_factors_cache = {}

    for prime in primes:
        if prime >= limit:
            break

        if direction == "preceding" and prime >= 3:
            if (is_tetraprime(prime-1, primes, primes_set, prime_factors_cache) and
                is_tetraprime(prime-2, primes, primes_set, prime_factors_cache)):
                result.append(prime)
        elif direction == "following" and prime <= limit - 2:
            if (is_tetraprime(prime+1, primes, primes_set, prime_factors_cache) and
                is_tetraprime(prime+2, primes, primes_set, prime_factors_cache)):
                result.append(prime)

    return result

def has_prime_factor_7(n, primes_list, primes_set, prime_factors_cache):
    """Check if a number has 7 as one of its prime factors."""
    if n in prime_factors_cache:
        factors = prime_factors_cache[n]
    else:
        factors = prime_factorization(n, primes_list, primes_set)
        prime_factors_cache[n] = factors

    return 7 in factors

def count_factor_7_primes(primes_list, primes, primes_set, direction):
    """Count primes whose neighboring pairs have at least one member with a prime factor of 7."""
    count = 0
    prime_factors_cache = {}

    for prime in primes_list:
        if direction == "preceding":
            neighbors = [prime-1, prime-2]
        else:  # following
            neighbors = [prime+1, prime+2]

        if any(has_prime_factor_7(n, primes, primes_set, prime_factors_cache) for n in neighbors):
            count += 1

    return count

def calculate_prime_gaps(primes_list):
    """Calculate the gaps between consecutive primes in the list."""
    if not primes_list or len(primes_list) < 2:
        return []

    return [primes_list[i] - primes_list[i-1] for i in range(1, len(primes_list))]

def calculate_gap_statistics(gaps):
    """Calculate min, median, and max gap statistics."""
    if not gaps:
        return None, None, None

    min_gap = min(gaps)
    max_gap = max(gaps)

    # Calculate median
    gaps_sorted = sorted(gaps)
    n = len(gaps_sorted)
    if n % 2 == 0:
        median_gap = int((gaps_sorted[n//2 - 1] + gaps_sorted[n//2]) / 2)
    else:
        median_gap = int(gaps_sorted[n//2])

    return min_gap, median_gap, max_gap

def format_primes_grid(primes_list, num_columns=10):
    """Format a list of primes into a grid with specified number of columns."""
    if not primes_list:
        return ""

    result = []
    for i in range(0, len(primes_list), num_columns):
        row = primes_list[i:i+num_columns]
        formatted_row = "  " + "  ".join(f"{p:6d}" for p in row)
        result.append(formatted_row)

    return "\n".join(result)

def print_prime_results(primes, count_with_factor_7, direction, limit, show_primes=True):
    """Print results for a set of primes with tetraprime neighbors."""
    direction_text = "preceding" if direction == "preceding" else "following"

    print(f"\nFound {len(primes)} primes under {limit:,} whose {direction_text} neighboring pair are tetraprimes")

    if show_primes and primes:
        print(":")
        print(format_primes_grid(primes))

    print(f"\nof which {count_with_factor_7} have a neighboring pair one of whose factors is 7.")

    # Calculate and print gap statistics
    gaps = calculate_prime_gaps(primes)
    if gaps:
        min_gap, median_gap, max_gap = calculate_gap_statistics(gaps)
        print(f"\nMinimum gap between those {len(primes)} primes: {min_gap}")
        print(f"Median gap between those {len(primes)} primes: {median_gap}")
        print(f"Maximum gap between those {len(primes)} primes: {max_gap}")

def solve_for_limit(limit):
    """Solve all parts of the problem for a given limit."""
    print(f"\nSolving for primes less than {limit:,}:")
    start_time = time.time()

    # Generate all primes up to the limit
    primes = sieve_of_eratosthenes(limit)
    primes_set = set(primes)

    # Find primes with tetraprime neighbors
    preceding_primes = find_primes_with_tetraprime_neighbors(primes, limit, "preceding")
    following_primes = find_primes_with_tetraprime_neighbors(primes, limit, "following")

    # Count primes with factor 7 in neighbors
    preceding_factor7_count = count_factor_7_primes(preceding_primes, primes, primes_set, "preceding")
    following_factor7_count = count_factor_7_primes(following_primes, primes, primes_set, "following")

    # Show results
    show_individual_primes = limit <= 100000
    print_prime_results(preceding_primes, preceding_factor7_count, "preceding", limit, show_individual_primes)
    print_prime_results(following_primes, following_factor7_count, "following", limit, show_individual_primes)

    elapsed_time = time.time() - start_time
    print(f"\nTime taken: {elapsed_time:.2f} seconds")

if __name__ == "__main__":
    print("Starting tetraprime neighbors analysis...")

    # Run all calculations sequentially
    print("\n---------- PRIMES UNDER 100,000 ----------")
    solve_for_limit(100000)

    print("\n---------- PRIMES UNDER 1,000,000 ----------")
    solve_for_limit(1000000)

    print("\n---------- PRIMES UNDER 10,000,000 ----------")
    solve_for_limit(10000000)

    print("\nAnalysis complete!")
