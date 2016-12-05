# resturns the sum of the proper divisors of n                    #
# if n = 1, 0 or -1, we return 0                                  #
PROC sum proper divisors = ( INT n )INT:
     BEGIN
         INT result := 0;
         INT abs n = ABS n;
         IF abs n > 1 THEN
             FOR d FROM ENTIER sqrt( abs n ) BY -1 TO 2 DO
                 IF abs n MOD d = 0 THEN
                     # found another divisor                      #
                     result +:= d;
                     IF d * d /= n THEN
                         # include the other divisor              #
                         result +:= n OVER d
                     FI
                 FI
             OD;
             # 1 is always a proper divisor of numbers > 1        #
             result +:= 1
         FI;
         result
     END # sum proper divisors # ;

# construct a table of the sum of the proper divisors of numbers  #
# up to 20 000                                                    #
INT max number = 20 000;
[ 1 : max number ]INT proper divisor sum;
FOR n TO UPB proper divisor sum DO proper divisor sum[ n ] := sum proper divisors( n ) OD;

# returns TRUE if n1 and n2 are an amicable pair FALSE otherwise  #
#         n1 and n2 are amicable if the sum of the proper diviors #
#         n1 = n2 and the sum of the proper divisors of n2 = n1   #
PROC is an amicable pair = ( INT n1, n2 )BOOL:
     ( proper divisor sum[ n1 ] = n2 AND proper divisor sum[ n2 ] = n1 );

# find the amicable pairs up to 20 000                            #
FOR p1 TO max number DO
    FOR p2 FROM p1 + 1 TO max number DO
        IF is an amicable pair( p1, p2 ) THEN
            print( ( whole( p1, -6 ), " and ", whole( p2, -6 ), " are a amicable pair", newline ) )
        FI
    OD
OD
