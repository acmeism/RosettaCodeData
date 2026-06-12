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

# emit an array of the decimal digits of the integer input, least significant digit first.
def digits:
  recurse( if . >= 10 then ((. - (.%10)) / 10) else empty end) | . % 10;

def digitSum:
  def add(s): reduce s as $_ (0; .+$_);
  add(digits);
