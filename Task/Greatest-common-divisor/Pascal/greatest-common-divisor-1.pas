PROGRAM EXRECURGCD.PAS;

{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}

(*)
    Free Pascal Compiler version 3.2.0 [2020/06/14] for x86_64
    The free and readable alternative at C/C++ speeds
    compiles natively to almost any platform, including raspberry PI
(*)

FUNCTION gcd_recursive(u, v: longint): longint;

    BEGIN
        IF ( v = 0 ) THEN Exit ( u ) ;
        result := gcd_recursive ( v, u MOD v ) ;
    END;

BEGIN

    WriteLn ( gcd_recursive ( 231, 7 ) ) ;

END.
