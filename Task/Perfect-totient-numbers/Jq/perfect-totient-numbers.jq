# jq optimizes the recursive call of _gcd in the following:
def gcd(a;b):
  def _gcd:
    if .[1] != 0 then [.[1], .[0] % .[1]] | _gcd else .[0] end;
  [a,b] | _gcd ;

def count(s): reduce s as $x (0; .+1);

# A perfect totient number is an integer that is equal to the sum of its iterated totients.
# aka Euler's phi function
def totient:
  . as $n
  | count( range(0; .) | select( gcd($n; .) == 1) );

# input: the cache
# output: the updated cache
def cachephi($n):
  ($n|tostring) as $s
  | if (has($s)|not) then .[$s] = ($n|totient) else . end ;

# Emit the stream of perfect totients
def perfect_totients:
  . as $n
  | foreach range(1; infinite) as $i ({cache: {}};
        .tot = $i
        | .tsum = 0
        | until( .tot == 1;
	     .tot as $tot
             | .cache |= cachephi($tot)
             | .tot = .cache[$tot|tostring]
             | .tsum += .tot);
        if .tsum == $i then $i else empty end );

"The first 20 perfect totient numbers:",
limit(20; perfect_totients)
