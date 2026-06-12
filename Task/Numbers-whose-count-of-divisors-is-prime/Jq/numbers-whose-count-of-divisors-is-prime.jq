def add(s): reduce s as $x (null; .+$x);

def count_divisors:
  add(
    if . == 1 then 1
    else . as $n
    | label $out
    | range(1; $n) as $i
    | ($i * $i) as $i2
    | if $i2 > $n then break $out
      else if $i2 == $n
           then 1
           elif ($n % $i) == 0
           then 2
           else empty
  	   end
      end
    end);

1000, 100000
| "\nn with odd prime divisor counts, 1 < n < \(.):",
  (range(1;.) | select(count_divisors | (. > 2 and is_prime)))
