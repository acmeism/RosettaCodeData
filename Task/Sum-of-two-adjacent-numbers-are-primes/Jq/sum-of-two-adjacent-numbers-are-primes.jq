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

def naive:
  limit(20;
    range(0; infinite) as $i
    | (2*$i + 1) as $q
    | select($q | is_prime)
    | "\($i) + \($i + 1) = \($q)" );

naive
