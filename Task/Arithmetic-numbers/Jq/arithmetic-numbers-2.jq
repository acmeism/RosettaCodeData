# proper_divisors returns a stream of unordered proper divisors of the input integer.
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

def composite:
  [limit(2; proper_divisors)] | length == 2;

def arithmetic_numbers:
  def average_is_integral(s):
    reduce s as $_ ({}; .sum += $_ | .n += 1)
    | (.sum % .n) == 0;

  1, (range(2; infinite) | select(average_is_integral(., proper_divisors)));
