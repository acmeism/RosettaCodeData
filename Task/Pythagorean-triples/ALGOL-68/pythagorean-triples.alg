BEGIN # find some Pythagorean triples ( a, b, c )                            #
      #           where a < b < c and a^2 + b^2 = c^2                        #

    INT max perimeter = 100;            # maximum a + b + c we will consider #
    INT max square    = max perimeter * max perimeter;
    # form a table of square roots of numbers to max perimeter ^ 2           #
    [ 1 : max square ]INT sr;
    FOR i TO UPB sr        DO sr[ i     ] := 0 OD;
    FOR i TO max perimeter DO sr[ i * i ] := i OD;

    PROC gcd = ( INT x, y )INT:                              # iterative gcd #
         BEGIN
            INT a := ABS x, b := ABS y;
            WHILE b /= 0 DO
               INT next a = b;
               b := a MOD b;
               a := next a
            OD;
            a
         END # gcd # ;

   # count the Pythagorean triples                                           #
   INT t count := 0, p count := 0;
   FOR a TO max perimeter DO
       INT a2 = a * a;
       FOR b FROM a + 1 TO max perimeter - a
       WHILE INT c = sr[ a2 + ( b * b ) ];
             a + b + c <= max perimeter
       DO    IF c > b THEN                                   # have a triple #
                 t count +:= 1;
                 IF gcd( a, b ) = 1 THEN           # have a primitive triple #
                     p count +:= 1
                 FI
             FI
       OD
    OD;
    print( ( "Pythagorean triples with perimeters up to ", whole( max perimeter, 0 ), ":", newline ) );
    print( ( "    Primitive: ", whole( p count, 0 ), newline ) );
    print( ( "    Total:     ", whole( t count, 0 ), newline ) )

END
