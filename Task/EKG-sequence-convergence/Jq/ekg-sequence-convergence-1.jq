# jq optimizes the recursive call of _gcd in the following:
def gcd(a;b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [a,b] | _gcd ;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;
