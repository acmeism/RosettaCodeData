BEGIN # construct number names from a number                                  #
    []STRING units
           = ( "one", "two",  "three", "four", "five", "six", "seven", "eight", "nine" );
    []STRING unit prefix
           = ( "ten", "twen", "thir",  "four", "fif", "six",  "seven", "eigh",  "nine" );
    []STRING singleth
           = ( "first", "second",  "third",  "fourth", "fifth"
             , "sixth", "seventh", "eighth", "nineth"
             );
    []STRING power suffix
           = ( "thousand", "million", "billion", "trillion", "quadrillion", "quintillion" );
    # returns n converted to a number name, n must be 1-99                    #
    #         if final is TRUE, the name will end in st, nd, rd, ...          #
    PROC two digits = ( INT n, BOOL final )STRING:
         IF   n < 10       THEN IF final THEN singleth[ n ] ELSE units[ n ] FI
         ELIF n = 10       THEN IF final THEN "tenth"       ELSE "ten"      FI
         ELIF n = 11       THEN IF final THEN "eleventh"    ELSE "eleven"   FI
         ELIF n = 12       THEN IF final THEN "twelfth"     ELSE "twelve"   FI
         ELIF n < 20       THEN unit prefix[ n - 10 ]
                              + IF final THEN "teenth" ELSE "teen" FI
         ELIF n MOD 10 = 0 THEN unit prefix[ n OVER 10 ]
                              + IF final THEN "tieth"  ELSE "ty"   FI
         ELSE unit prefix[ n OVER 10 ]
            + "ty "
            + IF final THEN singleth[ n MOD 10 ] ELSE units[ n MOD 10 ] FI
         FI # two digits # ;
    # returns n converted to a number name, n must be 1-999                   #
    #         if final is TRUE, the name will end in st, nd, rd, ...          #
    PROC three digits = ( INT n, BOOL final )STRING:
         IF   n < 100
         THEN two digits( n, final )
         ELIF STRING hundreds = units[ n OVER 100 ] + " hundred";
              INT    ending = n MOD 100;
              ending = 0
         THEN IF final THEN hundreds + "th" ELSE hundreds FI
         ELSE hundreds + " and " + two digits( ending, final )
         FI # three digits # ;
    # returns the "name" of n                                                 #
    OP NAME = ( LONG INT n )STRING:
       IF   n < 0 THEN "minus " + NAME - n
       ELIF n = 0 THEN "zeroth"
       ELSE
            # have a positive number to name                                  #
            LONG INT v         := n;
            STRING   result    := "";
            INT      power pos := 0;
            WHILE v /= 0 DO
                BOOL     final component = power pos = 0;
                INT v999 = SHORTEN ( v MOD 1000 );
                IF v999 /= 0 THEN
                    STRING component := three digits( v999, final component );
                    IF power pos > 0 THEN
                        component +:= " " + power suffix[ power pos ];
                        IF final component THEN component +:= "th" FI
                    FI;
                    IF power pos = 0 AND v > 1000 AND v999 < 100 THEN
                        "and " +=: component
                    FI;
                    IF result /= "" THEN component +:= " " FI;
                    component +=: result
                FI;
                power pos +:= 1;
                v OVERAB 1000
            OD;
            IF n MOD 1000 = 0 THEN result + "th" ELSE result FI
       FI # NAME # ;
CO  # not used in this task, but in general we might need the followingL      #
    # additional operator to handle shorter integers                          #
    OP NAME = ( INT       n )STRING: NAME LENG n;
    # additional operators to handle integers expressed in floating point     #
    OP NAME = ( LONG REAL n )STRING: NAME ENTIER n;
    OP NAME = ( REAL      n )STRING: NAME ENTIER n;
CO
    # task test cases                                                         #
    []LONG INT t = ( 1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23 456, 8 007 006 005 004 003 );
    FOR n FROM LWB t TO UPB t DO
        print( ( whole( t[ n ], -16 ), ": ", NAME t[ n ], newline ) )
    OD
END
