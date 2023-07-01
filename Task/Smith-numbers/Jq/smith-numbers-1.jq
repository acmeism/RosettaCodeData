def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    elif ($n % 5 == 0)  then $n == 5
    elif ($n % 7 == 0)  then $n == 7
    elif ($n % 11 == 0) then $n == 11
    elif ($n % 13 == 0) then $n == 13
    elif ($n % 17 == 0) then $n == 17
    elif ($n % 19 == 0) then $n == 19
    else {i:23}
         | until( (.i * .i) > $n or ($n % .i == 0); .i += 2)
	 | .i * .i > $n
    end;

def sum(s): reduce s as $x (null; . + $x);

# emit a stream of the prime factors as per prime factorization
def prime_factors:
  . as $num
  | def m($p):  # emit $p with appropriate multiplicity
      $num | while( . % $p == 0; . / $p )
      | $p ;
  if (. % 2) == 0 then m(2) else empty end,
  (range(3; 1 + (./2); 2)
    | select(($num % .) == 0 and is_prime)
    | m(.));
