fun isLeapYear y =
  y mod (if y mod 100 = 0 then 400 else 4) = 0
