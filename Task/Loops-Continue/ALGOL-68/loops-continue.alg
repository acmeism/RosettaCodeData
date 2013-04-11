FOR i FROM 1 TO 10 DO
  print ((i,
    IF i MOD 5 = 0 THEN
      new line
    ELSE
      ","
    FI
  ))
OD
