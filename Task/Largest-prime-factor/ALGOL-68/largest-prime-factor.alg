BEGIN # find the largest prime factor of a number #
    # returns the largest prime factor of n #
    PROC max prime factor = ( LONG INT n )LONG INT:
         IF   n < 2
         THEN 1
         ELSE
             LONG INT max factor := n;
             # even factors - only 2 is prime #
             LONG INT v := n;
             WHILE NOT ODD v DO
                 max factor := 2;
                 v OVERAB 2
             OD;
             # odd factors #
             LONG INT k := 3;
             LONG INT root n = ENTIER long sqrt( n );
             WHILE k <= root n AND v > 1 DO
                 WHILE v MOD k = 0 AND v > 1 DO
                     max factor := k;
                     v OVERAB k
                 OD;
                 k +:= 2
             OD;
             IF v > 1 THEN v ELSE max factor FI
        FI # max prime factor # ;
    # test the max prime factor routine #
    PROC test = ( LONG INT n )VOID:
         print( ( "Largest prime factor of ", whole( n, 0 ), " is ", whole( max prime factor( n ), 0 ), newline ) );
    # test cases #
    test( 600 851 475 143 );
    test(           6 008 );
    test(             751 )
END
