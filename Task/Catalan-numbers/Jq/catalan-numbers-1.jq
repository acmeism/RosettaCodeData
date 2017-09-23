def catalan:
  if . == 0 then 1
  elif . < 0 then error("catalan is not defined on \(.)")
  else (2 * (2*. - 1) * ((. - 1) | catalan)) / (. + 1)
  end;
