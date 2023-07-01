BEGIN # find solutions to the "Prime Triangle" - a triangle of numbers that sum to primes #
    INT max number = 18; # largest number we will consider #
    # construct a primesieve and from that a table of pairs of numbers whose sum is prime #
    [ 0 : 2 * max number ]BOOL prime;
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # returns the number of possible arrangements of the integers for a row in the prime triangle #
    PROC count arrangements = ( INT n )INT:
         IF   n < 2 THEN # no solutions for n < 2 # 0
         ELIF n < 4 THEN
             # for 2 and 3. there is only 1 solution: 1, 2 and 1, 2, 3 #
             FOR i TO n DO print( ( whole( i, -3 ) ) ) OD; print( ( newline ) );
             1
         ELSE
             # 4 or more - must find the solutions #
             BOOL print solution := TRUE;
             [ 0 : n ]BOOL used;
             [ 0 : n ]INT  number;
             # the triangle row must have 1 in the leftmost and n in the rightmost elements #
             # the numbers must alternate between even and odd in order for the sum to be prime #
             FOR i FROM 0 TO n DO
                 used[   i ] := FALSE;
                 number[ i ] := i MOD 2
             OD;
             used[   1 ] := TRUE;
             number[ n ] := n;
             used[   n ] := TRUE;
             # find the intervening numbers and count the solutions #
             INT count := 0;
             INT p     := 2;
             WHILE p > 0 DO
                 INT p1      = number[ p - 1 ];
                 INT current = number[ p     ];
                 INT next   := current + 2;
                 WHILE IF next >= n THEN FALSE ELSE NOT prime[ p1 + next ] OR used[ next ] FI DO
                     next +:= 2
                 OD;
                 IF next >= n THEN next := 0 FI;
                 IF p = n - 1 THEN
                     # we are at the final number before n #
                     # it must be the final even/odd number preceded by the final odd/even number #
                     IF next /= 0 THEN
                         # possible solution #
                         IF prime[ next + n ] THEN
                             # found a solution #
                             count +:= 1;
                             IF print solution THEN
                                 FOR i TO n - 2 DO
                                     print( ( whole( number[ i ], -3 ) ) )
                                 OD;
                                 print( ( whole( next, -3 ), whole( n, - 3 ), newline ) );
                                 print solution := FALSE
                             FI
                         FI;
                         next := 0
                     FI;
                     # backtrack for more solutions #
                     p -:= 1
                     # here will be a further backtrack as next is 0 ( there could only be one possible number at p - 1 ) #
                 FI;
                 IF next /= 0 THEN
                     # have a/another number that can appear at p #
                     used[ current ] := FALSE;
                     used[    next ] := TRUE;
                     number[     p ] := next;
                     p +:= 1
                 ELIF p <= 2 THEN
                     # no more solutions #
                     p := 0
                 ELSE
                     # can't find a number for this position, backtrack #
                     used[ number[ p ] ] := FALSE;
                     number[       p   ] := p MOD 2;
                     p -:= 1
                 FI
             OD;
             count
         FI # count arrangements # ;
    [ 2 : max number ]INT arrangements;
    FOR n FROM LWB arrangements TO UPB arrangements DO
        arrangements[ n ] := count arrangements( n )
    OD;
    FOR n FROM LWB arrangements TO UPB arrangements DO
        print( ( " ", whole( arrangements[ n ], 0 ) ) )
    OD;
    print( ( newline ) )
END
