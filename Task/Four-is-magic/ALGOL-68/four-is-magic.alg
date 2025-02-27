BEGIN # construct number names from a number                                  #
    MODE NUMBER = LONG INT;        # adjust to suit, must be at least 64 bits #
    OP TOINT = ( NUMBER n )INT: SHORTEN n;                   # adjust to suit #
    []STRING units
           = ( "one", "two",  "three", "four", "five", "six", "seven", "eight", "nine" );
    []STRING teens
           = ( "ten",     "eleven",  "twelve",    "thirteen", "fourteen"
             , "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
             );
    []STRING tens
           = ( "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety" );
    []STRING power suffix
           = ( "thousand", "million", "billion", "trillion", "quadrillion", "quintillion" );
    # returns n converted to a number name, n must be in range 1-99           #
    PROC two digits = ( INT n )STRING:
         IF   n < 10
         THEN units[ n ]
         ELIF n < 20
         THEN teens[ n - 9 ]
         ELIF INT last1 = n MOD 10;
              last1 = 0
         THEN tens[ ( n OVER 10 ) - 1 ]
         ELSE tens[ ( n OVER 10 ) - 1 ] + " " + units[ last1 ]
         FI # two digits # ;
    # returns n converted to a number name, n must be in range 1-999          #
    PROC three digits = ( INT n )STRING:
         IF   n < 100
         THEN two digits( n )
         ELIF STRING hundreds = units[ n OVER 100 ] + " hundred";
              INT    last2 = n MOD 100;
              last2 = 0
         THEN hundreds
         ELSE hundreds + " " + two digits( last2 )
         FI # three digits # ;
    # returns the "name" of n                                                 #
    OP NAME = ( NUMBER n )STRING:
       IF   n < 0 THEN "negative " + NAME - n
       ELIF n = 0 THEN "zero"
       ELSE # have a positive number to name                                  #
            NUMBER   v         := n;
            STRING   result    := "";
            INT      power pos := 0;
            WHILE v /= 0 DO
                IF   INT v999 = TOINT ( v MOD 1000 );
                     v999 /= 0
                THEN STRING component := three digits( v999 );
                     IF power pos > 0 THEN
                         component +:= " " + power suffix[ power pos ]
                     FI;
                     IF result /= "" THEN component +:= " " FI;
                     component +=: result
                FI;
                power pos +:= 1;
                v OVERAB 1000
            OD;
            result
       FI # NAME # ;
    # returns the "x is y, y is z, ... four is magic" sequence derived from n #
    OP MAGIC = ( NUMBER n )STRING:
       BEGIN
          NUMBER   v      := n;
          STRING   result := "";
          WHILE v /= 4 DO
              IF result /= "" THEN result +:= ", " FI;
              STRING v name = NAME v;
              v       := ( UPB v name - LWB v name ) + 1;
              result +:= v name + " is " + NAME v
          OD;
          IF result /= "" THEN result +:= ", " FI;
          result + "four is magic"
       END # MAGIC # ;
    # test cases                                                              #
    []NUMBER t = ( 0, 1, 2, 3, 4, 5, 100, 101, 272, 1701, 1968, 4077, 90 210
                 , - 100 001, 987 654, - NUMBER( 8 007 006 005 004 003 )
                 );
    FOR n FROM LWB t TO UPB t DO
        print( ( whole( t[ n ], -18 ), ": ", MAGIC t[ n ], newline ) )
    OD
END
