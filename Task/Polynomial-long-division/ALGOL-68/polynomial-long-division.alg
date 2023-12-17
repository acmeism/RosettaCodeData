BEGIN # polynomial division                                         #
      # in this polynomials are represented by []INT items where    #
      # the coefficients are in order of increasing powers, i.e.,   #
      # element 0 = coefficient of x^0, element 1 = coefficient of  #
      # x^1, etc.                                                   #

    # returns the degree of the polynomial p, the highest index of  #
    #         p where the element is non-zero or - max int if all   #
    #         elements of p are 0                                   #
    OP   DEGREE = ( []INT p )INT:
         BEGIN
             INT result := - max int;
             FOR i FROM LWB p TO UPB p DO
                 IF p[ i ] /= 0 THEN result := i FI
             OD;
             result
         END # DEGREE # ;

    MODE POLYNOMIALDIVISIONRESULT = STRUCT( FLEX[ 1 : 0 ]INT q, r );

    # in-place multiplication of the elements of a by b returns a   #
    OP   *:= = ( REF[]INT a, INT b )REF[]INT:
         BEGIN
            FOR i FROM LWB a TO UPB a DO
                a[ i ] *:= b
            OD;
            a
         END # *:= # ;
    # subtracts the corresponding elements of b from those of a,    #
    #           a and b must have the same bounds - returns a       #
    OP   -:= = ( REF[]INT a, []INT b )REF[]INT:
         BEGIN
            FOR i FROM LWB a TO UPB a DO
                a[ i ] -:= b[ i ]
            OD;
            a
         END # -:= # ;
    # returns the polynomial a right-shifted by shift, the bounds    #
    #         are unchanged, so high order elements are lost         #
    OP   SHR = ( []INT a, INT shift )[]INT:
         BEGIN
            INT da = DEGREE a;
            [ LWB a : UPB a ]INT result;
            FOR i FROM LWB result TO shift - ( LWB result + 1 ) DO result[ i ] := 0 OD;
            FOR i FROM shift - LWB result TO UPB result DO result[ i ] := a[ i - shift ] OD;
            result
         END # SHR # ;

    # polynomial long disivion of n in by d in, returns q and r      #
    OP   / = ( []INT n in, d in )POLYNOMIALDIVISIONRESULT:
         IF DEGREE d < 0 THEN
             print( ( "polynomial division by polynomial with negative degree", newline ) );
             stop
         ELSE
             [ LWB d in : UPB d in ]INT d := d in;
             [ LWB n in : UPB n in ]INT n := n in;
             [ LWB n in : UPB n in ]INT q; FOR i FROM LWB q TO UPB q DO q[ i ] := 0 OD;
             INT dd in = DEGREE d in;
             WHILE DEGREE n >= dd in DO
                 d := d in SHR ( DEGREE n - dd in );
                 q[ DEGREE n - dd in ] := n[ DEGREE n ] OVER d[ DEGREE d ];
                 # DEGREE d is now DEGREE n                          #
                 d *:= q[ DEGREE n - dd in ];
                 n -:= d
             OD;
             ( q, n )
         FI # / # ;

    # displays the polynomial p                                      #
    OP   SHOWPOLYNOMIAL = ( []INT p )VOID:
         BEGIN
            BOOL first := TRUE;
            FOR i FROM UPB p BY - 1 TO LWB p DO
                IF INT e = p[ i ];
                   e /= 0
                THEN
                    print( ( IF   e < 0 AND first THEN "-"
                             ELIF e < 0           THEN " - "
                             ELIF           first THEN ""
                             ELSE                      " + "
                             FI
                           , IF ABS e = 1 THEN "" ELSE whole( ABS e, 0 ) FI
                           )
                         );
                    IF i > 0 THEN
                        print( ( "x" ) );
                        IF i > 1 THEN print( ( "^", whole( i, 0 ) ) ) FI
                    FI;
                    first := FALSE
                FI
            OD;
            IF first THEN
                # degree is negative                                 #
                print( ( "(negative degree)" ) )
            FI
         END # SHOWPOLYNOMIAL # ;

    []INT n = ( []INT( -42, 0, -12, 1 ) )[ AT 0 ];
    []INT d = ( []INT(  -3, 1,   0, 0 ) )[ AT 0 ];

    POLYNOMIALDIVISIONRESULT qr = n / d;

    SHOWPOLYNOMIAL n; print( ( " divided by " ) ); SHOWPOLYNOMIAL d;
    print( ( newline, " -> Q: " ) ); SHOWPOLYNOMIAL q OF qr;
    print( ( newline, "    R: " ) ); SHOWPOLYNOMIAL r OF qr

END
