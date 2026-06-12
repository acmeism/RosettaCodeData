# Output: a stream of the primes
def primes: 2, (range(3; infinite; 2) | select(is_prime));

# The task
# jq uses an index-origin of 1 and so:
nth(10000; primes)
