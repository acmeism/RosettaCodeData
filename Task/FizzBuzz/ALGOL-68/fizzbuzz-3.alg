FOR i TO 100 DO
    IF  IF i MOD 3 = 0 THEN print( "Fizz" ); FALSE ELSE TRUE FI
    AND IF i MOD 5 = 0 THEN print( "Buzz" ); FALSE ELSE TRUE FI
    THEN
        print( ( whole( i, 0 ) ) )
    FI;
    print( ( newline ) )
OD
