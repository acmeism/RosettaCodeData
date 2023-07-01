# nCk assuming n >= k
def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) / $i)
  end;

def task:
  .[0] as $n | .[1] as $k
  | "\($n) C \($k) = \(binomial( $n; $k) )";
;

([5,3], [100,2], [ 33,17]) | task
