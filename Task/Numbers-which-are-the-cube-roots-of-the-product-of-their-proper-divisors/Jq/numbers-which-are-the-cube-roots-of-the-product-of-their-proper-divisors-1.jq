# Notice that `prod(empty)` evaluates to 1.
def prod(s): reduce s as $x (1; . * $x);

# Output: the unordered stream of proper divisors of .
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
