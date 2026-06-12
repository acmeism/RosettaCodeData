# Input: the maximum width
# Output: a stream
def extraprimes:
  [2,3,5,7] as $p
  # Input: width
  # Output: a stream of arrays of length $n drawn from $p
  | def wide: . as $n | if . == 0 then [] else $p[] | [.] + (($n-1)|wide) end;

  range(1;.+1) as $maxlen
  | ($maxlen | wide)
  | select( add | is_prime)
  | join("")
  | tonumber
  | select(is_prime) ;

# The task:
4|extraprimes
