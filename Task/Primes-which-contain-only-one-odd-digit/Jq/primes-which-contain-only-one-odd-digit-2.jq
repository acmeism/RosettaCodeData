# Input is assumed to be prime.
# So we only need check the other digits are all even.
def prime_has_exactly_one_odd_digit:
  if . == 2 then false
  # The codepoints for the odd digits are also odd: [49,51,53,55,57]
  else all(tostring | explode[:-1][];  . % 2 == 0)
  end;

def primes_with_exactly_one_odd_digit_crudely:
  # It is much faster to check for primality afterwards.
  range(3; infinite; 2)
  | select(prime_has_exactly_one_odd_digit and is_prime);
