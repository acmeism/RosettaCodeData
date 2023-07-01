PROGRAM Ulam.pas;


{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}


(*)
        Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI

        https://www.freepascal.org/advantage.var
(*)

    USES
        Crt,
        SysUtils ;

    CONST
         (*)
            Only odd numbers work
         (*)
         SIZE    = 9 ;
         MSIZE   = SIZE * ord ( Odd ( SIZE ) ) ;

    TYPE
        D2Arr = array of array of string ;


    FUNCTION IsPrime ( n: integer ): boolean ;

        VAR
            i:   integer;

        BEGIN

            IF ( n < 2 )        THEN    Exit ( False ) ;
            IF ( n = 2 )        THEN    Exit ( True  ) ;
            IF ( n mod 2 = 0 )  THEN    Exit ( False ) ;

            FOR i := 3 TO Trunc ( Sqrt ( n ) ) DO
                IF  ( n mod i = 0 ) THEN    Exit( False ) ;

            IsPrime := True ;

        END;


    PROCEDURE  Init2DArr ( Arr: D2Arr ) ;

        VAR
              j: integer;
            mid: integer = MSIZE div 2 ;

        BEGIN

            FOR j:= 1 to MSIZE - mid - 1 DO
                BEGIN
                    Arr [ mid - j ] [ mid - j     ] := '.' ;
                    Arr [ mid - j ] [ mid + j     ] := '.' ;
                    Arr [ mid + j ] [ mid - j     ] := '.' ;
                    Arr [ mid + j ] [ mid + j - 1 ] := '.' ;
                END;

        END;


    PROCEDURE Advance ( var Turn_cnt, x, y: integer ) ;

        VAR
            dir:    array   [ 0..3, 0..1 ]  of  shortint =
                    ( (  1,  0 ), (  0, -1 ), ( -1,  0 ), (  0,  1 ) ) ;

        BEGIN

            x   := Abs ( x + dir [ Turn_cnt mod 4 ][ 0 ] ) ;
            y   := Abs ( y + dir [ Turn_cnt mod 4 ][ 1 ] ) ;

        END;


    PROCEDURE  Add2DArr ( Arr: D2Arr ) ;

        VAR

            cnt:        integer =           1 ;
            Turn_cnt:   integer =           0 ;
            x:          integer = MSIZE div 2 ;
            y:          integer = MSIZE div 2 ;

        BEGIN

            WHILE ( cnt < MSIZE * MSIZE ) DO
                BEGIN

                    Advance ( Turn_cnt , x , y ) ;
                    Inc ( cnt ) ;

                    IF  ( Arr [ x ] [ y ] = '.' )   THEN
                        BEGIN
                            Arr [ x ] [ y ] := '' ;
                            inc ( Turn_cnt ) ;
                        END;

                    IF  ( IsPrime ( cnt ) ) THEN
                        Arr [ x ] [ y ] := IntToStr ( cnt ) ;

                END;

        END;


    PROCEDURE  Show2DArr ( Arr: D2Arr ; glyph : Boolean ) ;

        VAR
            x, y:  integer ;

        BEGIN

            WriteLn ;

            FOR y := Low ( Arr ) TO High ( Arr ) DO
                BEGIN
                    FOR x := Low ( Arr [ y ] ) to High ( Arr [ y ] ) DO

                        IF  length ( Arr [ x ] [ y ] ) > 0  THEN
                            IF  glyph   THEN    Write ( '′' : 3 )
                            ELSE    Write ( Arr [ x ] [ y ] : 3 )
                        ELSE Write ( ' ' : 3) ;

                    WriteLn;
                END;

            WriteLn;

        END;


VAR
    Arr:       D2Arr ;

BEGIN

    IF ( MSIZE = 0 ) THEN
        BEGIN
            WriteLn ( 'Only odd numbers work for SIZE' ) ;
            Exit;
        END;
    SetLength   ( Arr, MSIZE, MSIZE ) ;
    Init2DArr   ( Arr ) ;
    Add2DArr    ( Arr ) ;
    Show2DArr   ( Arr , False ) ;
    Show2DArr   ( Arr , True ) ;

END.
