def left_factorial:
  reduce range(1; .+1) as $i
  # state: [i!, !i]
    ([1,0]; .[1] += .[0] | .[0] *= $i)
  | .[1];
