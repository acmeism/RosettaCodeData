def count(s): reduce s as $x (null; .+1);

def is_attractive:
  count(prime_factors) | is_prime;

def printattractive($m; $n):
  "The attractive numbers from \($m) to \($n) are:\n",
  [range($m; $n+1) | select(is_attractive)];

printattractive(1; 120)
