# For the sake of gojq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

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
    else
      ($n | sqrt) as $rt
      | 23
      | until( . > $rt or ($n % . == 0); .+2)
      | . > $rt
    end;

# jq optimizes the recursive call of _gcd in the following:
def gcd(a;b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [a,b] | _gcd ;

def count(s): reduce s as $x (0; .+1);

def totient:
  . as $n
  | count( range(0; .) | select( gcd($n; .) == 1) );
