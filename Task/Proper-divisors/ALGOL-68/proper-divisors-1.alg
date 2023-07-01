# MODE to hold an element of a list of proper divisors            #
MODE DIVISORLIST = STRUCT( INT divisor, REF DIVISORLIST next );

# end of divisor list value                                       #
REF DIVISORLIST nil divisor list = REF DIVISORLIST(NIL);

# resturns a DIVISORLIST containing the proper divisors of n      #
# if n = 1, 0 or -1, we return no divisors                        #
PROC proper divisors = ( INT n )REF DIVISORLIST:
     BEGIN
         REF DIVISORLIST result   := nil divisor list;
         REF DIVISORLIST end list := result;
         INT abs n  = ABS n;
         IF abs n > 1 THEN
             # build the list of divisors backeards, so they are  #
             # returned in ascending order                        #
             INT root n = ENTIER sqrt( abs n );
             FOR d FROM root n BY -1 TO 2 DO
                 IF abs n MOD d = 0 THEN
                     # found another divisor                      #
                     result := HEAP DIVISORLIST
                            := DIVISORLIST( d, result );
                     IF end list IS nil divisor list THEN
                         # first result                           #
                         end list := result
                     FI;
                     IF d * d /= n THEN
                         # add the other divisor to the end of    #
                         # the list                               #
                         next OF end list := HEAP DIVISORLIST
                                          := DIVISORLIST( abs n OVER d, nil divisor list );
                         end list         := next OF end list
                     FI
                 FI
             OD;
             # 1 is always a proper divisor of numbers > 1        #
             result := HEAP DIVISORLIST
                    := DIVISORLIST( 1, result )
         FI;
         result
     END # proper divisors # ;

# returns the number of divisors in a DIVISORLIST                 #
PROC count divisors = ( REF DIVISORLIST list )INT:
     BEGIN
        INT result := 0;
        REF DIVISORLIST divisors := list;
        WHILE divisors ISNT nil divisor list DO
            result +:= 1;
            divisors := next OF divisors
        OD;
        result
     END # count divisors # ;

# find the proper divisors of 1 : 10                              #
FOR n TO 10 DO
    REF DIVISORLIST divisors := proper divisors( n );
    print( ( "Proper divisors of: ", whole( n, -2 ), ": " ) );
    WHILE divisors ISNT nil divisor list DO
        print( ( " ", whole( divisor OF divisors, 0 ) ) );
        divisors := next OF divisors
    OD;
    print( ( newline ) )
OD;

# find the first/only number in 1 : 20 000 with the most divisors  #
INT max number         = 20 000;
INT max divisors      :=      0;
INT has max divisors  :=      0;
INT with max divisors :=      0;
FOR d TO max number DO
    INT divisor count = count divisors( proper divisors( d ) );
    IF divisor count > max divisors THEN
        # found a number with more divisors than the previous max  #
        max divisors       := divisor count;
        has max divisors   := d;
        with max divisors  := 1
    ELIF divisor count = max divisors THEN
        # found another number with that many divisors             #
        with max divisors +:= 1
    FI
OD;
print( ( whole( has max divisors, 0 )
       , " is the "
       , IF with max divisors < 2 THEN "only" ELSE "first" FI
       , " number upto "
       , whole( max number, 0 )
       , " with "
       , whole( max divisors, 0 )
       , " divisors"
       , newline
       ) )
