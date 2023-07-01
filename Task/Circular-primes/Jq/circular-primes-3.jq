last(limit(19; circular_primes)) as $max
| limit(4; repunits | select(. > $max and is_prime))
| "R(\(tostring|length))"
