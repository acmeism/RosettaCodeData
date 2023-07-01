def sum(stream): reduce stream as $i (0; . + $i);

def classify:
  . as $n
  | sum(proper_divisors)
  | if . < $n then "deficient" elif . == $n then "perfect" else "abundant" end;

reduce (range(1; 20001) | classify) as $c ({}; .[$c] += 1 )
