BEGIN # find elements of the Euclid-Mullin sequence: starting from 2,         #
      # the next element is the smallest prime factor of 1 + the product      #
      # of the previous elements                                              #
    print( ( " 2" ) );
    LONG LONG INT product := 2;
    FROM 2 TO 16 DO
        LONG LONG INT next := product + 1;
        # find the first prime factor of next                                 #
        LONG LONG INT p := 3;
        BOOL      found := FALSE;
        WHILE p * p <= next AND NOT ( found := next MOD p = 0 ) DO
            p +:= 2
        OD;
        IF found THEN next := p FI;
        print( ( " ", whole( next, 0 ) ) );
        product *:= next
    OD
END
