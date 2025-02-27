import math
from collections import defaultdict


def generate_primes_sieve(n):
    if n == 0:
        return []
    if n <= 6:
        upper_bound = 12
    else:
        upper_bound = int(n * (math.log(n) + math.log(math.log(n)))) + 1
    sieve = [True] * (upper_bound + 1)
    sieve[0] = sieve[1] = False
    for i in range(2, int(math.sqrt(upper_bound)) + 1):
        if sieve[i]:
            sieve[i * i: upper_bound + 1: i] = [False] * len(sieve[i * i: upper_bound + 1: i])
    primes = []
    for i in range(2, upper_bound + 1):
        if sieve[i]:
            primes.append(i)
            if len(primes) == n:
                break
    return primes


def factor(n, primes_list, primes_set):
    factors = []
    if n == 1:
        return factors
    for p in primes_list:
        if p * p > n:
            break
        while n % p == 0:
            factors.append(p)
            n = n // p
    if n > 1 and n in primes_set:
        factors.append(n)
    return factors


def compute_categories(primes):
    primes_set = set(primes)
    category = {p: 0 for p in primes}
    for p in primes:
        m = p + 1
        factors = factor(m, primes, primes_set)
        if all(f in {2, 3} for f in factors):
            category[p] = 1
        else:
            max_cat = 0
            for q in factors:
                q_cat = category.get(q, 0)
                if q_cat > max_cat:
                    max_cat = q_cat
            category[p] = max_cat + 1
    return category


def print_first_200(primes, category):
    print("First 200 primes sorted by category:")
    print("-" * 34)

    # Create list of (category, prime, original_position)
    sorted_primes = sorted(
        [(category[p], p, i + 1) for i, p in enumerate(primes[:200])],
        key=lambda x: (x[0], x[1])
    )
    # Group by category for better visualization
    current_category = None
    for cat, p, orig_pos in sorted_primes:
        if cat != current_category:
            print(f"\nCategory {cat}:")
            current_category = cat
        print(f"{p}", end=" ")


def process_million_primes():
    n = 10 ** 6
    primes = generate_primes_sieve(n)
    primes = primes[:n]
    category = compute_categories(primes)

    stats = defaultdict(lambda: {'count': 0, 'min': None, 'max': None})
    for p in primes:
        cat = category[p]
        stats[cat]['count'] += 1
        if stats[cat]['min'] is None or p < stats[cat]['min']:
            stats[cat]['min'] = p
        if stats[cat]['max'] is None or p > stats[cat]['max']:
            stats[cat]['max'] = p

    print("\n\nCategory statistics for first 1,000,000 primes:")
    print(f"{'Category':<8} {'Count':>12} {'Smallest':>12} {'Largest':>12}")
    print("-" * 48)
    for cat in sorted(stats.keys()):
        s = stats[cat]
        print(f"{cat:<8} {s['count']:>12,} {s['min']:>12,} {s['max']:>12,}")


# First part: Display first 200 primes sorted by category
primes_200 = generate_primes_sieve(200)
primes_200 = primes_200[:200]
category_200 = compute_categories(primes_200)
print_first_200(primes_200, category_200)

# Second part: Process first million primes and display statistics
process_million_primes()
