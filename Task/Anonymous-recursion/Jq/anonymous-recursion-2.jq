def fib(n):
  if n < 0 then error("negative arguments not allowed")
  else [2, 0, 1]
  | recurse( if .[0] > n then empty
             else [ .[0]+1, .[2], .[1]+.[2] ]
             end)
  | .[1]
  end;
