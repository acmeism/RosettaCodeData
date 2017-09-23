# unordered
def proper_divisors:
  . as $n
  | if $n > 1 then 1,
      (sqrt|floor as $s
      | range(2; $s+1) as $i
      | if ($n % $i) == 0 then $i,
           (if $i * $i == $n then empty else ($n / $i) end)
	else empty
	end)
    else empty
    end;

def addup(stream): reduce stream as $i (0; . + $i);

def task(n):
  (reduce range(0; n+1) as $n
    ( [];  . + [$n | addup(proper_divisors)] )) as $listing
  | range(1;n+1) as $j
  | range(1;$j) as $k
  | if $listing[$j] == $k and $listing[$k] == $j
    then "\($k) and \($j) are amicable"
    else empty
    end ;

task(20000)
