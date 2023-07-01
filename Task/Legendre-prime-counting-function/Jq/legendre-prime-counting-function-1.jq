# For the sake of the accuracy of integer arithmetic when using gojq:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

# Input: $n, which is assumed to be positive integer,
# Output: an array of primes less than or equal to $n (e.g. 10|eratosthenes #=> [2,3,5,7]
def eratosthenes:
  # erase(i) sets .[i*j] to false for integral j > 1
  def erase(i):
    if .[i] then
      reduce range(2; (1 + length) / i) as $j (.; .[i * $j] = false)
    else .
    end;

  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i))
  | map(select(.)) ;
