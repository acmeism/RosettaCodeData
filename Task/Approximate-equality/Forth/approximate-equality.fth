: test-f~   ( f1 f2 -- )
  1e-18                  \ epsilon
  f~                     \ AproximateEqual
  if ." True" else ." False" then
;
