def count(s): reduce s as $x (null; .+1);

def task($n):
  [2, (range(3;$n;2)|select(is_prime))]
  | . as $p
  | range(0; length) as $i
  | range($i+1; length) as $j
  | range($j+1; length) as $k
  | [.[$i], .[$j], .[$k]]
  | select( add| is_prime) ;

task(30),
"\nStretch goal: \(count(task(1000)))"
