# To take advantage of gojq's arbitrary-precision integer arithmetic:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;

# This is fast because the state of `until` is just a number
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
    elif ($n % 23 == 0) then $n == 23
    elif ($n % 29 == 0) then $n == 29
    elif ($n % 31 == 0) then $n == 31
    elif ($n % 37 == 0) then $n == 37
    elif ($n % 41 == 0) then $n == 41
    else 43
    | until( (. * .) > $n or ($n % . == 0); . + 2)
    | . * . > $n
    end;
