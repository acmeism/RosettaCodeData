# Output: an unbounded stream of palindromic primes
def palindromic_primes:

  # Output: a naively constructed stream of palindromic strings of length >= 2
  def palindromic_candidates:
    def rev: # reverse a string
      explode|reverse|implode;
    def unconstrained($length):
      if $length==1 then range(0;10) | tostring
      else (range(0;10)|tostring)
      | . + unconstrained($length -1 )
      end;
    def middle($length):  # $length > 0
      if $length==1 then range(0;10) | tostring
      elif $length % 2 == 1
      then (($length -1) / 2) as $len
      | unconstrained($len) as $left
      | (range(0;10) | tostring) as $mid
      | $left + $mid + ($left|rev)
      else ($length / 2) as $len
      | unconstrained($len) as $left
      | $left + ($left|rev)
      end;

  # palindromes with an even number of digits are divisible by 11

    range(1;infinite;2) as $mid
    | ("1", "3", "7", "9") as $start
    | $start + middle($mid) + $start ;

  2, 3, 5, 7, 11,
  (palindromic_candidates | tonumber | select(is_prime));
