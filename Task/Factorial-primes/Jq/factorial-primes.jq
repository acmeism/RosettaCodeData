# The algorithm is quite fast because the state of `until` is just a number and we skip by 2 or 4
def is_prime:
  . as $n
  | if ($n < 2)         then false
    elif ($n % 2 == 0)  then $n == 2
    elif ($n % 3 == 0)  then $n == 3
    else 5
    | until( . <= 0;
        if .*. > $n then -1
	elif ($n % . == 0) then 0
        else . + 2
        |  if ($n % . == 0) then 0
           else . + 4
           end
        end)
     | . == -1
     end;

def factorial_primes:
  foreach range(1; infinite) as $i (1; . * $i;
    if ((.-1) | is_prime) then [($i|tostring) + "! - 1 = ", .-1] else empty end,
    if ((.+1) | is_prime) then [($i|tostring) + "! + 1 = ", .+1] else empty end ) ;

limit(20; factorial_primes)
| .[1] |= (tostring | (if length > 40 then .[:20] + " .. " + .[-20:] else . end))
| add
