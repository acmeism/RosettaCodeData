def gcd(a; b):
  def _gcd:
    if .[1] == 0 then .[0]
    else [.[1], .[0] % .[1]] | _gcd
    end;
  [a,b] | _gcd ;

# Return: [total, primitives] for pythagorean triangles having
# perimeter no larger than peri.
# The following uses Euclid's formula with the convention: m > n.
def count(peri):

  # The inner function can be used to count for a given value of m:
  def _count:
    # state [n,m,p, [total, primitives]]
    .[0] as $n | .[1] as $m | .[2] as $p
    | if $n < $m and $p <= peri then
        if (gcd($m;$n) == 1)
        then .[3] | [ (.[0] + ((peri/$p)|floor) ),  (.[1] + 1)]
        else .[3]
        end
        | [$n+2, $m, $p+4*$m, .] | _count
      else .
      end;

  # m^2 < m*(m+1) <= m*(m+n) = perimeter/2
  reduce range(2;  (peri/2) | sqrt + 1) as $m
    ( [1, 2, 12, [0,0]];
      (($m % 2) + 1) as $n
      | (2 * $m * ($m + $n) ) as $p   # a+b+c for this (m,n)
      | [$n, $m, $p, .[3]] | _count
    ) | .[3] ;

# '''Example''':
def pow(i): . as $in | reduce range(0; i) as $j (1; . * $in);

range(1; 9) | . as $i | 10|pow($i) as $i | "\($i):  \(count($i) )"
