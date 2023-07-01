def primes:
  2, range(3; infinite; 2) | select(is_prime);

# generate an infinite stream of primorials beginning with primorial(0)
def primorials:
  0, foreach primes as $p (1; .*$p; .);

"The first ten primorial numbers are:",
limit(10; primorials),

"\nThe primorials with the given index have the lengths shown:",
([10, 100, 1000, 10000, 100000] as $sample
| limit($sample|length;
    foreach primes as $p ([0,1];   # [index, primorial]
      .[0]+=1 | .[1] *= $p;
      select(.[0]|IN($sample[])) | [.[0], (.[1]|tostring|length)] ) ))
