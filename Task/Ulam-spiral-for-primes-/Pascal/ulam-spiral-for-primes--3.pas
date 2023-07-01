PROGRAM Ulam8.pas;

{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}

(*)
        Free `translation` from PHIX for the Spiral part

        Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        For debian Linux: apt -y install fpc
		It contains a text IDE called fp

        https://www.freepascal.org/advantage.var

(*)

USES

    crt;

CONST

    SIZE    = 9                             ; // `SIZE = 9 : "The Iceskater" ( Obvious when Dutch ) `
    n       = SIZE * ord ( Odd ( SIZE ) )   ;

    CrLf    = #13#10                        ;


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


    FUNCTION Spiral ( w, h, x, y : integer ) : integer ;

        BEGIN

            IF ( y > 0 )  THEN
                Spiral := w + Spiral ( h - 1, w, y - 1, w - x - 1 )
            ELSE
                Spiral := x

        END ;

    PROCEDURE PrintSpiral ( s : string ) ;

        VAR

            h   : integer = n   ;
            i   : integer       ;
            j   : integer       ;
            p   : integer       ;
            w   : integer = n   ;

        BEGIN

            FOR i := h - 1 DOWNTO 0 DO
                BEGIN
                    FOR j := w - 1 DOWNTO 0 DO
                        BEGIN

                            p := w * h - Spiral ( w, h, j, i ) ;
                            IF IsPrime ( p ) THEN
                                IF ( s = '' ) THEN Write ( p:3 ) ELSE Write ( '`':3 )
                            ELSE  Write ( ' ':3 )

                        END;
                    WriteLn ;
                END ;
        END ;

BEGIN

    IF ( n = 0 ) THEN
        BEGIN
            WriteLn ( 'Only odd numbers work for SIZE' ) ;
            Exit;
        END;

    PrintSpiral ( '' )       ;
    WriteLn ( CrLf )         ;
    PrintSpiral ( 'Symbol' ) ;

END.
