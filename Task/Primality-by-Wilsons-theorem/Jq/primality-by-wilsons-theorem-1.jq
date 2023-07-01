## Compute (n - 1)! mod m.
def facmod($n; $m):
  reduce range(2; $n+1) as $k (1; (. * $k) % $m);

def isPrime: .>1 and (facmod(. - 1; .) + 1) % . == 0;

"Prime numbers between 2 and 100:",
[range(2;101) | select (isPrime)],

# Notice that `infinite` can be used as the second argument of `range`:
"First 10 primes after 7900:",
[limit(10; range(7900; infinite) | select(isPrime))]
