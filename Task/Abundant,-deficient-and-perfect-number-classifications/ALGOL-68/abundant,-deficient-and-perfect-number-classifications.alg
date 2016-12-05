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

# classify the numbers 1 : 20 000 as abudant, deficient or perfect #
INT abundant count    := 0;
INT deficient count   := 0;
INT perfect count     := 0;
INT abundant example  := 0;
INT deficient example := 0;
INT perfect example   := 0;
INT max number         = 20 000;
FOR n TO max number DO
    IF     INT pd sum = sum proper divisors( n );
           pd sum < n
    THEN
        # have a deficient number                                  #
        deficient count    +:= 1;
        deficient example   := n
    ELIF   pd sum = n
    THEN
        # have a perfect number                                    #
        perfect count      +:= 1;
        perfect example     := n
    ELSE # pd sum > n #
        # have an abundant number                                  #
        abundant count     +:= 1;
        abundant example    := n
    FI
OD;

# show how many of each type of number there are and an example    #

# displays the classification, count and example                   #
PROC show result = ( STRING classification, INT count, example )VOID:
     print( ( "There are "
            , whole( count, -8 )
            , " "
            , classification
            , " numbers up to "
            , whole( max number, 0 )
            , " e.g.: "
            , whole( example, 0 )
            , newline
            )
          );

show result( "abundant ",  abundant count,  abundant example  );
show result( "deficient", deficient count, deficient example );
show result( "perfect  ",   perfect count,   perfect example   )
