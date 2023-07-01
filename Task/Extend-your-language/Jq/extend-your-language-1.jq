def if2($c1; $c2; both; first; second; neither):
  if $c1 and $c2 then both
  elif $c1 then first
  elif $c2 then second
  else neither
  end;
