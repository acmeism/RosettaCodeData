PROGRAM EXBigFac ;

{$IFDEF FPC}
    {$mode objfpc}{$H+}{$J-}{R+}
{$ELSE}
    {$APPTYPE CONSOLE}
{$ENDIF}

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

    gmp;

    FUNCTION WriteBigNum ( c: pchar ) : ansistring ;

    CONST

        CrLf = #13 + #10 ;

    VAR
        i:              longint;
        len:            longint;
        preview:        integer;
        ret:    ansistring = '';
        threshold:      integer;

    BEGIN

        len		:=	length ( c ) ;
        WriteLn ( 'Digits:  ', len ) ;
        threshold	:= 12 ;
        preview 	:= len div threshold ;

        IF	( len < 91 ) THEN
            BEGIN
                FOR i := 0 TO len DO
                    ret:= ret + c [ i ] ;
            END
        ELSE
            BEGIN
                FOR i := 0 TO preview DO
                    ret:= ret + c [ i ] ;
                    ret:= ret + '...'  ;
                FOR i := len - preview -1  TO len DO
                    ret:= ret + c [ i ] ;
            END;
        ret:= ret + CrLf ;
        WriteBigNum := ret;
    END;

    FUNCTION BigFactorial ( n : qword ) : ansistring ;

    (*)
	See https://gmplib.org/#DOC
    (*)

    VAR
        S:	mpz_t;
        c:	pchar;

    BEGIN

        mpz_init_set_ui          ( S, 1 ) ;
        mpz_fac_ui               ( S, n ) ;
        c := mpz_get_str   ( NIL, 10, S ) ;
        BigFactorial := WriteBigNum ( c ) ;

    END;

BEGIN

    WriteLn ( BigFactorial ( 99 ) ) ;

END.

Output:
Digits:  156
93326215443944...00000000000000
