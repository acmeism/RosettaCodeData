# Denoting the input by $n, which is assumed to be a positive integer,
# eratosthenes/0 produces an array of primes less than or equal to $n:
def eratosthenes:

  def erase(i):
    if .[i] then
      reduce (range(2*i; length; i)) as $j (.; .[$j] = false)
    else .
    end;

  (. + 1) as $n
  | (($n|sqrt) / 2) as $s
  | [null, null, range(2; $n)]
  | reduce (2, 1 + (2 * range(1; $s))) as $i (.; erase($i))
  | map(select(.));
