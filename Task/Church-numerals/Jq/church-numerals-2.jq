def church(f; $m):
  if $m < 0 then error("church is not defined on negative integers")
  elif $m == 0 then .
  elif $m == 1 then f
  else church(f; $m - 1) | f
  end;
