# jq optimizes the recursive call of _gcd in the following:
def gcd(a;b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [a,b] | _gcd ;

def count(s): reduce s as $x (0; .+1);

def totient:
  . as $n
  | count( range(0; .) | select( gcd($n; .) == 1) );

# input: determines the maximum via range(0; .)
# and so may be `infinite`
def primes_via_totient:
  range(0; .) | select(totient == . - 1);
