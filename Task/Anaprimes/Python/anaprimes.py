# def sieve(limit):
#     """Generate list of primes up to the given limit using the Sieve of Eratosthenes."""
#     sieve = [True] * (limit + 1)
#     sieve[0:2] = [False, False]  # 0 and 1 are not primes
#     for num in range(2, int(limit**0.5) + 1):
#         if sieve[num]:
#             sieve[num*num : limit+1 : num] = [False] * len(range(num*num, limit+1, num))
#     primes = [num for num, is_prime in enumerate(sieve) if is_prime]
#     return primes


def sieve(limit):
    """Generate list of primes up to the given limit using the Sieve of Atkin."""
    # Handle edge cases
    if limit < 2:
        return []

    # Initialize the sieve with False
    sieve = [False] * (limit + 1)

    # Mark sieve[2] and sieve[3] as True (primes)
    if limit >= 2:
        sieve[2] = True
    if limit >= 3:
        sieve[3] = True

    # Main loop to mark numbers based on Atkin's rules
    for x in range(1, int(limit ** 0.5) + 1):
        for y in range(1, int(limit ** 0.5) + 1):
            # First condition: (4x² + y²) % 12 == 1 or 5
            n = 4 * x ** 2 + y ** 2
            if n <= limit and (n % 12 == 1 or n % 12 == 5):
                sieve[n] = not sieve[n]

            # Second condition: (3x² + y²) % 12 == 7
            n = 3 * x ** 2 + y ** 2
            if n <= limit and n % 12 == 7:
                sieve[n] = not sieve[n]

            # Third condition: (3x² - y²) % 12 == 11 (only if x > y)
            n = 3 * x ** 2 - y ** 2
            if x > y and n <= limit and n % 12 == 11:
                sieve[n] = not sieve[n]

    # Eliminate all squares of primes
    for i in range(5, int(limit ** 0.5) + 1):
        if sieve[i]:
            for k in range(i ** 2, limit + 1, i ** 2):
                sieve[k] = False

    # Collect all primes
    primes = [i for i in range(limit + 1) if sieve[i]]
    return primes

def group_anagrams(primes):
    """Group primes by their sorted digits."""
    anagram_groups = {}
    for prime in primes:
        sorted_digits = ''.join(sorted(str(prime)))
        if sorted_digits in anagram_groups:
            anagram_groups[sorted_digits].append(prime)
        else:
            anagram_groups[sorted_digits] = [prime]
    return anagram_groups

def find_largest_group(anagram_groups):
    """Find the largest group of anagram primes."""
    largest_group = max(anagram_groups.values(), key=lambda x: len(x))
    return largest_group

def get_group_info(group):
    """Get count, smallest, and largest primes from a group."""
    count = len(group)
    min_prime = min(group)
    max_prime = max(group)
    return count, min_prime, max_prime

def main():
    """Main function to process different ranges and display results."""
    limits = [10**3, 10**4, 10**5, 10**6, 10**7, 10**8, 10**9]
    for limit in limits:
        primes = sieve(limit)
        anagram_groups = group_anagrams(primes)
        largest_group = find_largest_group(anagram_groups)
        count, min_prime, max_prime = get_group_info(largest_group)
        print(f"Up to {limit}: Count={count}, Min={min_prime}, Max={max_prime}")

if __name__ == "__main__":
    main()
