from itertools import permutations
from math import isqrt

# -------------------------
# Function: is_prime
# -------------------------
def is_prime(n):
    if n < 2:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    for i in range(3, isqrt(n) + 1, 2):
        if n % i == 0:
            return False
    return True

# -------------------------
# Function: should_skip_digits
# Skip digits if digit-sum is divisible by 3 (primality impossible)
# -------------------------
def should_skip_digits(digits):
    return sum(digits) % 3 == 0

# -------------------------
# Function: generate_pandigital_numbers
# -------------------------
def generate_pandigital_numbers(limit):
    pandigital_nums = []

    for n in range(1, 10):  # digits 1 to 9
        digits = list(range(1, n + 1))

        if should_skip_digits(digits):
            continue

        for p in permutations(digits):
            num = int(''.join(map(str, p)))
            if num < limit:
                pandigital_nums.append(num)

    return pandigital_nums

# -------------------------
# Main driver
# -------------------------
def find_prime_pandigitals(limit):
    pandigitals = generate_pandigital_numbers(limit)

    prime_pandigitals = list(filter(is_prime, pandigitals))

    print(f"Largest prime pandigital number: {max(prime_pandigitals) if prime_pandigitals else 'None'}")

# -------------------------
# Run the program
# -------------------------
LIMIT = 987654321
find_prime_pandigitals(LIMIT)

