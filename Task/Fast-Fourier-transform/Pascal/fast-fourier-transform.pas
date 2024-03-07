PROGRAM RDFT;

(*)

        Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        For debian Linux: apt -y install fpc
        It contains a text IDE called fp

        https://www.freepascal.org/advantage.var

(*)

USES

    crt,
    math,
    sysutils,
    ucomplex;

	{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
    (*) Use for variants and ucomplex (*)


TYPE

    table = array  of complex;



PROCEDURE Split ( T: table ; EVENS: table; ODDS:table ) ;

    VAR

        k:  integer ;

    BEGIN

        FOR k := 0 to Length ( T ) - 1 DO

            IF Odd ( k ) THEN

                ODDS [ k DIV 2 ]    := T [ k ]

            ELSE

                EVENS [ k DIV 2 ]   := T [ k ]

    END;



PROCEDURE WriteCTable ( L: table ) ;

    VAR

        x   :integer ;

    BEGIN

        FOR x := 0  to length ( L ) - 1 DO

            BEGIN

                Write   ( Format ('%3.3g ' , [ L [ x ].re ] ) ) ;

                IF ( L [ x ].im >= 0.0 ) THEN Write ( '+' ) ;

                WriteLn ( Format ('%3.5gi' , [ L [ x ].im ] ) ) ;

            END ;

    END;



FUNCTION FFT ( L : table ): table ;

    VAR

        k       :   integer ;
        N       :   integer ;
        halfN   :   integer ;
        E       :   table   ;
        Even    :   table   ;
        O       :   table   ;
        Odds    :   table   ;
        T       :   complex ;

    BEGIN

        N   :=  length ( L )        ;

        IF N < 2 THEN

            EXIT ( L )  ;

        halfN := ( N DIV 2 )        ;

        SetLength ( E,    halfN )   ;

        SetLength ( O,    halfN )   ;

        Split     ( L, E, O )       ;

        SetLength ( L, 0 )   	    ;

        SetLength ( Even, halfN )   ;

        Even :=     FFT ( E )       ;

        SetLength ( E   , 0 )       ;

        SetLength ( Odds, halfN )   ;

        Odds :=     FFT ( O )       ;

        SetLength ( O   , 0 )       ;

        SetLength ( L,    N )       ;

        FOR k := 0 to halfN - 1 DO

            BEGIN

                T               := Cexp ( -2 * i * pi * k / N ) * Odds [ k ];

                L [ k ]         := Even [ k ] + T                      	    ;

                L [ k + halfN ] := Even [ k ] - T                      	    ;

            END ;

        SetLength ( Even, 0 )   ;

        SetLength ( Odds, 0 )   ;

        FFT :=  L               ;

    END ;



VAR

    Ar  :   array of complex ;

    x   :   integer ;

BEGIN



    SetLength ( Ar, 8 ) ;

    FOR x := 0 TO 3 DO

	BEGIN

	    Ar [ x ]        :=  1.0 ;

	    Ar [ x + 4 ]    :=  0.0 ;
			
	END;

    WriteCTable ( FFT ( Ar ) )  ;

    SetLength ( Ar, 0 ) ;



END.
(*)
    Output:

        4 +  0i
        1 -2.4142i
        0 +  0i
        1 -0.41421i
        0 +  0i
        1 +0.41421i
        0 +  0i
        1 +2.4142i
