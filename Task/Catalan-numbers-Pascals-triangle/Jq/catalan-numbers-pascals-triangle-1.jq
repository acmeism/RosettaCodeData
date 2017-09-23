def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) / $i)
  end;

# Direct (naive) computation using two numbers in Pascal's triangle:
def catalan_by_pascal: . as $n | binomial(2*$n; $n) - binomial(2*$n; $n-1);
