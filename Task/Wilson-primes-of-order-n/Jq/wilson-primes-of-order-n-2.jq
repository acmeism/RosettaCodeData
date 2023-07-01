# Input: the limit of $p
def wilson_primes:
  def sgn: if . % 2 == 0 then 1 else -1 end;

  . as $limit
  | factorials as $facts
  | " n:  Wilson primes\n--------------------",
    (range(1;12) as $n
     | "\($n|lpad(2)) :  \(
       [emit_until( . >= $limit; primes)
        | select(. as $p
            | $p >= $n and
              (($facts[$n - 1] * $facts[$p - $n] - ($n|sgn))
               % ($p*$p) == 0 )) ])" );

11000 | wilson_primes
