def is_circular_prime:
    def circle: range(0;length) as $i | .[$i:] + .[:$i];
    tostring as $s
    | [$s|circle|tonumber] as $c
    | . == ($c|min) and all($c|unique[]; is_prime);

def circular_primes:
   2, (range(3; infinite; 2) | select(is_circular_prime));

# Probably only useful with unbounded-precision integer arithmetic:
def repunits:
  1 | recurse(10*. + 1);
