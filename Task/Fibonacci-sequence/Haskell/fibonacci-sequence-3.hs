fib x = if x < 1 then 0
                 else if x==1 then 1
                 else fibs!!(x - 1) + fibs!!(x - 2)
  where
  fibs = map fib [0..]
