def count(stream): reduce stream as $i (0; . + 1);

# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      ( range(2; 1 + (sqrt|floor)) as $i
        | if ($n % $i) == 0 then $i,
            (($n / $i) | if . == $i then empty else . end)
         else empty
	 end)
    else empty
    end;

# The first integer in 1 .. n inclusive
# with the maximal number of proper divisors in that range:
def most_proper_divisors(n):
  reduce range(1; n+1) as $i
    ( [null, 0];
      count( $i | proper_divisors ) as $count
      | if $count > .[1] then [$i, $count] else . end);
