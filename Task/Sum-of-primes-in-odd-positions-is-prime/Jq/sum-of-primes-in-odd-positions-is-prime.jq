def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def task:
  [2, (range(3;1000;2)|select(is_prime))]
  | [.[range(0;length;2)]]
  | . as $oddPositionPrimes
  | foreach range(0; length) as $i ({i: -1};
      .i += 2
      | .sum += $oddPositionPrimes[$i];
      select(.sum|is_prime)
      | "\(.i|lpad(3))  \($oddPositionPrimes[$i]|lpad(3)) \(.sum|lpad(5))" ) ;

 "  i  p[$i] sum", task
