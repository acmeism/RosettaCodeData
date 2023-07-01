# calculate the first few catalan numbers, using LONG INT values        #
# (64-bit quantities in Algol 68G which can handle up to C23)           #

# returns n!/k!                                                         #
PROC factorial over factorial = ( INT n, k )LONG INT:
     IF      k > n THEN 0
     ELIF    k = n THEN 1
     ELSE #  k < n #
         LONG INT f := 1;
         FOR i FROM k + 1 TO n DO f *:= i OD;
         f
     FI # factorial over factorial # ;

# returns n!                                                             #
PROC factorial = ( INT n )LONG INT:
     BEGIN
         LONG INT f := 1;
         FOR i FROM 2 TO n DO f *:= i OD;
         f
     END # factorial # ;

# returnss the nth Catalan number using binomial coefficeients            #
# uses the factorial over factorial procedure for a slight optimisation   #
# note:     Cn = 1/(n+1)(2n n)                                            #
#              = (2n)!/((n+1)!n!)                                         #
#              = factorial over factorial( 2n, n+1 )/n!                   #
PROC catalan = ( INT n )LONG INT: IF n < 2 THEN 1 ELSE factorial over factorial( n + n, n + 1 ) OVER factorial( n ) FI;

# show the first few catalan numbers                                      #
FOR i FROM 0 TO 15 DO
    print( ( whole( i, -2 ), ": ", whole( catalan( i ), 0 ), newline ) )
OD
