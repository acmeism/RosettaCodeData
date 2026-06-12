BEGIN # Nimber arithmetic - translated from the EasyLang/FreeBASIC samples   #

    PR read "bits.incl.a68" PR          # include bit-manipulation utilities #

    # returns the highest power of 2 that divides n                          #
    PROC hpo2  = ( INT n )INT: n AND - n;
    # returns the base 2 logarithm of the highest power of 2 dividing n      #
    PROC lhpo2 = ( INT n )INT:
         BEGIN
            INT m := hpo2( n ), q := 0;
            WHILE NOT ODD m DO
                m SHRAB 1;
                q +:= 1
            OD;
            q
         END # lpho2 # ;

    # returns the nim-sum of x and y; x, y must be >= 0                      #
    PROC nimsum  = ( INT x, y )INT: x XOR y;
    # returns the nim-product of x and y; x, y must be >= 0                  #
    PROC nimprod = ( INT x, y )INT:
         IF x < 2 OR y < 2
         THEN x * y
         ELSE INT h := hpo2( x );
              IF x > h THEN
                 nimprod( h, y ) XOR nimprod( x XOR h, y )
              ELIF hpo2( y ) < y THEN
                 nimprod( y, x )
              ELSE
                 INT xp   = lhpo2( x )
                   , yp   = lhpo2( y );
                 INT comp = xp AND yp;
                 IF comp = 0 THEN
                     x * y
                 ELSE
                     h := hpo2( comp );
                     nimprod( nimprod( x SHR h, y SHR h ), 3 SHL ( h - 1 ) )
                 FI
              FI
         FI # nimprod # ;

    BEGIN
        PROC show nim table = ( INT lo, hi, width, STRING op name, PROC(INT,INT)INT nimop )VOID:
             BEGIN
                print( ( "  ", op name, " |" ) );
                FOR a FROM lo TO hi DO print( ( whole( a, - width ) ) ) OD;
                print( ( newline, "-" * width, "-+", "-" * width * ( hi + 1 - lo ), newline ) );
                FOR b FROM lo TO hi DO
                    print( ( whole( b, - width ), " |" ) );
                    FOR a FROM lo TO hi DO print( ( whole( nimop( a, b ), - width ) ) ) OD;
                    print( ( newline ) )
                OD;
                print( ( newline ) )
             END # show nim table # ;

        show nim table( 0, 15, 3, "+", nimsum  );
        show nim table( 0, 15, 3, "*", nimprod );

        INT n51 = 21508, n52 = 42689;
        print( ( whole( n51, 0 ), " + ", whole( n52, 0 ), " = ", whole(  nimsum( n51, n52 ), 0 ), newline ) );
        print( ( whole( n51, 0 ), " * ", whole( n52, 0 ), " = ", whole( nimprod( n51, n52 ), 0 ), newline ) )
    END
END
