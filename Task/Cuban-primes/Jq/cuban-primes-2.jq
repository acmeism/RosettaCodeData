# Emit an unbounded stream
# The differences between successive cubes: 3n(n+1)+1
def cubanprimes:
  foreach range(1;infinite) as $i (null;
     (3 * $i * ($i + 1) + 1) as $d
     | if $d|is_prime then $d else null end;
     select(.) );

(200
 | "The first \(.) cuban primes are:",
 ([limit(.; cubanprimes) | commatize | lpad(10)] | nwise(10) | join(" "))),

"\nThe 100,000th cuban prime is \(nth(100000 - 1; cubanprimes) | commatize)"
