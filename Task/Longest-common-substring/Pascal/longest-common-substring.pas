PROGRAM LongestCommonSubString.pas;


{$IFDEF FPC}
	{$mode objfpc}{$H+}{$J-}{$m+}{$R+}{$T+}
{$ELSE}
	{$APPTYPE CONSOLE}
{$ENDIF}

(*)

		Free Pascal Compiler version 3.2.2 [2022/08/01] for x86_64

        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        https://www.freepascal.org/advantage.var

		Version without `USES    SysUtils, Variants ;` and without `SubStr`, we do not need it here...


(*)

	FUNCTION IFF ( Cond: boolean;  A, B: string ) : string ;
	
		BEGIN		IF ( Cond ) THEN IFF := A ELSE IFF := B ;		END ;


    FUNCTION lcss( S1, S2: string ) : string ;

		VAR
	
			j :	Integer =	0 ;

			k :	Integer =	0 ;

			S :	string  =  '' ;

		BEGIN


			lcss	:= ''	  ;

			FOR j := 0 TO length ( S1 ) DO 	BEGIN

				FOR k := length ( S1 ) - j DOWNTO 1 DO	BEGIN

					S := Copy(S1, (j + 1), (k + j + 1)) ;

					IF	( pos ( S, S2 )  > 0  )	AND
						( length ( S ) > length ( lcss ) ) THEN	 BEGIN
							
						lcss := S ;
									
						BREAK ;
									
					END ;

				END ;

			END ;


		END ;	(*)	FUNCTION lcss	(*)



VAR

    S1: string =  'thisisatest'       		;

    S2: string =  'testing123testing'	;


BEGIN

    IF ParamCount = 2 THEN  BEGIN

		S1 := IFF( ( ParamStr ( 1 ) > '' ), ParamStr ( 1 ) , S1 );

		S2 := IFF( ( ParamStr ( 2 ) > '' ), ParamStr ( 2 ) , S1 );

    END;

    Writeln ( 'string A = ', S1 )  ;

    Writeln ( 'string B = ', S2 )  ;

    WriteLn (  Lcss ( S1, S2 )  )  ;

END. (*) Of PROGRAM LongestCommonSubString.pas (*)

(*)
