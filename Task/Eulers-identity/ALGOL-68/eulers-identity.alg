BEGIN
    # calculate an approximation to e^(i pi) + 1 which should be 0 (Euler's identity) #

    # returns e^ix for long real x, using the series:                                 #
    #      exp(ix) = 1 - x^2/2! + x^4/4! - ... + i(x - x^3/3! + x^5/5! - x^7/7! ... ) #
    #      the expansion stops when successive terms differ by less than 1e-15        #
    PROC expi = ( LONG REAL x )LONG COMPL:
         BEGIN
            LONG REAL t              := 1;
            LONG REAL real part      := 1;
            LONG REAL imaginary part := 0;
            LONG REAL divisor        := 1;
            BOOL      even power     := FALSE;
            BOOL      subtract       := FALSE;
            LONG REAL diff           := 1;
            FOR n FROM 1 WHILE ABS diff > 1e-15 DO
                divisor *:= n;
                t       *:= x;
                LONG REAL e term := t / divisor;
                IF even power THEN
                    # this term is real #
                    subtract := NOT subtract;
                    LONG REAL prev := real part;
                    IF subtract THEN
                        real part -:= e term
                    ELSE
                        real part +:= e term
                    FI;
                    diff := prev - real part
                ELSE
                    # this term is imaginary #
                    LONG REAL prev := imaginary part;
                    IF subtract THEN
                        imaginary part -:= e term
                    ELSE
                        imaginary part +:= e term
                    FI;
                    diff := prev - imaginary part
                FI;
                even power := NOT even power
            OD;
            ( real part, imaginary part )
         END # expi # ;
    LONG COMPL eulers identity = expi( long pi ) + 1;
    print( ( "e^(i*pi) + 1 ~ "
           , fixed( re OF eulers identity, -23, 20 )
           , " "
           , fixed( im OF eulers identity,  23, 20 )
           , "i"
           , newline
           )
         )
END
