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

# Emit an array of primes less than `.`
def primes:
  if . < 2 then []
  else
    [2] + [range(3; .; 2) | select(is_prime)]
  end;

# for the sake of infinite-precision integer arithmetic
def power($b): . as $a | reduce range(0; $b) as $i (1; .*$a);
