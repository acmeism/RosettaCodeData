BEGIN
    # aliquot sequence classification                                         #
    # maximum sequence length we consider                                     #
    INT max sequence length = 16;
    # possible classifications                                                #
    STRING         perfect classification    = "perfect        ";
    STRING        amicable classification    = "amicable       ";
    STRING        sociable classification    = "sociable       ";
    STRING        aspiring classification    = "aspiring       ";
    STRING          cyclic classification    = "cyclic         ";
    STRING     terminating classification    = "terminating    ";
    STRING non terminating classification    = "non terminating";
    # structure to hold an aliquot sequence and its classification            #
    MODE ALIQUOT = STRUCT( STRING                              classification
                         , [ 1 : max sequence length ]LONG INT sequence
                         , INT                                 length
                         );
    # maximum value for sequence elements - if any element is more than this, #
    # we assume it is non-teriminating                                        #
    LONG INT max element = 140 737 488 355 328;
    # returns the sum of the proper divisors of n                             #
    OP DIVISORSUM = ( LONG INT n )LONG INT:
       BEGIN
            LONG INT abs n = ABS n;
            IF abs n < 2 THEN
                0 # -1, 0 and 1 have no proper divisors                       #
            ELSE
                # have a number with possible divisors                        #
               LONG INT result := 1; # 1 is always a divisor                  #
               # a FOR loop counter can only be an INT, hence the WHILE loop  #
               LONG INT d      := ENTIER long sqrt( abs n );
               WHILE d > 1 DO
                   IF abs n MOD d = 0 THEN
                       # found another divisor                                #
                       result +:= d;
                       IF d * d /= abs n THEN
                           # add the other divisor                            #
                           result +:= abs n OVER d
                       FI
                   FI;
                   d -:= 1
               OD;
               result
            FI
       END # DIVISORSUM # ;
    # generates the aliquot sequence of the number k and its classification   #
    # at most max elements of the sequence are considered                     #
    OP CLASSIFY = ( LONG INT k )ALIQUOT :
       BEGIN
           ALIQUOT result;
           classification OF result := "non-terminating";
           INT lb = LWB sequence OF result;
           INT ub = UPB sequence OF result;
           ( sequence OF result )[ lb ] := k; # the first element is always k #
           length     OF result         := 1;
           FOR i FROM lb + 1 TO ub DO
               ( sequence OF result )[ i ] := 0
           OD;
           BOOL classified := FALSE;
           LONG INT prev k := k;
           FOR i FROM lb + 1 TO ub WHILE NOT classified DO
               length OF result +:= 1;
               LONG INT next k := ( sequence OF result )[ i ] := DIVISORSUM prev k;
               classified := TRUE;
               IF   next k = 0 THEN # the sequence terminates                 #
                    classification OF result := terminating classification
               ELIF next k > max element THEN # the sequence gets too large   #
                    classification OF result := non terminating classification
               ELIF next k = k THEN # the sequence that returns to k          #
                   classification OF result
                       := IF   i = lb + 1 THEN  perfect classification
                          ELIF i = lb + 2 THEN amicable classification
                          ELSE                 sociable classification
                          FI
               ELIF next k = prev k THEN # the sequence repeats with non-k    #
                   classification OF result := aspiring classification
               ELSE # check for repeating sequence with a period more than 1  #
                   classified := FALSE;
                   FOR prev pos FROM lb TO i - 2 WHILE NOT classified DO
                       IF classified := ( sequence OF result )[ prev pos ] = next k THEN
                           # found a repeatition                              #
                           classification OF result := cyclic classification
                       FI
                   OD
               FI;
               prev k := next k
           OD;
           result
       END # CLASSIFY # ;
    # test cases as per the task                                              #
    []LONG INT test cases =
        (   1,    2,   3,   4,   5,    6,     7,       8,   9,  10
        ,  11,   12,  28, 496, 220, 1184, 12496, 1264460, 790, 909
        , 562, 1064, 1488
        ,  15355717786080
        );
    FOR i FROM LWB test cases TO UPB test cases DO
        LONG INT k   := test cases[ i ];
        ALIQUOT  seq  = CLASSIFY k;
        print( ( whole( k, -14 ), ": ", classification OF seq, ":" ) );
        FOR e FROM LWB sequence OF seq + 1 TO length OF seq DO
            print( ( " ", whole( ( sequence OF seq )[ e ], 0 ) ) )
        OD;
        print( ( newline ) )
    OD
END
