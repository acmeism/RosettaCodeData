let
  qs = l:
    if l == [] then []
    else
      with builtins;
      let x  = head l;
          xs = tail l;
          low  = filter (a: a < x)  xs;
          high = filter (a: a >= x) xs;
      in qs low ++ [x] ++ qs high;
in
  qs [4 65 2 (-31) 0 99 83 782]
