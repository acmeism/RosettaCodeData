def church(f; $x; $m):
  if $m == 0 then .
  elif $m == 1 then $x|f
  else church(f; $x; $m - 1)
  end;
