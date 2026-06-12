# Output: a stream of strings of pandigital numbers
# drawing from the digits in the input array,
# in descending numerical order
def candidates:
  . as $use
  | if . == [] then ""
    else .[] as $i
    | ($use - [$i] | candidates) as $j
    | "\($i)\($j)"
    end;

# Output: a stream in descending numerical order
def pandigital_primes:
  range(9; 0; -1)
  | [range(.; 0; -1)]
  | candidates
  | tonumber
  | select(is_prime);

first(pandigital_primes)
