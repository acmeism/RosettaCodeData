# Input: a number n
# Output: an array of additive primes less than n
def additive_primes:
  primes
  | . as $primes
  | reduce .[] as $p (null;
      ( $p | sumdigits ) as $sum
      | if (($primes | bsearch($sum)) > -1)
        then . + [$p]
        else .
        end );

"Erdős primes under 500:",
(500 | additive_primes
 | ((nwise(10) | map(lpad(4)) | join(" ")),
   "\n\(length) additive primes found."))
