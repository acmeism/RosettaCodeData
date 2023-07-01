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
    else 23
    | until( (. * .) > $n or ($n % . == 0); .+2)
	| . * . > $n
    end;

# Output: a stream
def deceptives:
  {nextrepunit: 1111111111111111}
  | foreach range(17; infinite; 2) as $n (.;
      .repunit = .nextrepunit
      | .nextrepunit |= . * 100 + 11;
      select( ($n | is_prime | not)
               and ($n % 3 != 0) and ($n % 5 != 0)
               and (.repunit % $n == 0 ))
      | $n );

"The first 25 deceptive numbers are:", [limit(25;deceptives)]
