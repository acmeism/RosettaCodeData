main:(
  FOR i TO 100 DO
    printf(($gl$,
      IF i %* 15 = 0 THEN
        "FizzBuzz"
      ELIF i %* 3 = 0 THEN
        "Fizz"
      ELIF i %* 5 = 0 THEN
        "Buzz"
      ELSE
        i
      FI
    ))
  OD
)
