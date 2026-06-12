def is_prime(n):
    """Check if a number is prime."""
    if n <= 1:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def sum_of_digits(n):
    """Calculate the repeated sum of digits until the sum's length is 1."""
    while n > 9:
        n = sum(int(digit) for digit in str(n))
    return n

def find_nice_primes(lower_limit=501, upper_limit=1000):
    """Find all Nice primes within the specified range."""
    nice_primes = []
    for n in range(lower_limit, upper_limit):
        if is_prime(n):
            sumn = sum_of_digits(n)
            if is_prime(sumn):
                nice_primes.append(n)
    return nice_primes

# Example usage
nice_primes = find_nice_primes()
print(nice_primes)
