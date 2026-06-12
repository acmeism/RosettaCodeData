# Output: a stream of [decimal, hexadecimal] values
def palindromic_primes_in_base_16:
  (2, (range(3; infinite; 2) | select(is_prime)))
  | exploded_hex as $hex
  |select( $hex | (. == reverse))
  | [., ($hex|implode)] ;

emit_until(.[0] >= 500; palindromic_primes_in_base_16)
