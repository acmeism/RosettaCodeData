def is_prime:
  if  . == 2 then true
  else
     2 < . and . % 2 == 1 and
       (. as $in
       | (($in + 1) | sqrt) as $m
       | [false, 3] | until( .[0] or .[1] > $m; [$in % .[1] == 0, .[1] + 2])
       | .[0]
       | not)
  end ;

def relatively_prime:
  .[0] as $n
  | .[1] as $primes
  | ($n | sqrt) as $s
  | (.[1] | length) as $length
  | [0, true]
  | until( .[0] > $length or ($primes[.[0]] > $s) or .[1] == false;
          [.[0] + 1, ($n % $primes[.[0]] != 0)] )
  | .[1] ;

def primes:
  # The helper function, next, has arity 0 for tail recursion optimization;
  # its input must be an array of primes of length at least 2,
  # the last also being the greatest.
  def next:
     . as $previous
     | .[length-1] as $last
     | [(2 + $last), $previous]
     | until( relatively_prime ; .[0] += 2) as $nextp
     | ( $previous + [$nextp[0]] );
  2, ([2,3] | recurse( next ) | .[-1]) ;
