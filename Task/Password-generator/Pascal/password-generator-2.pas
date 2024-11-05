PROGRAM pwgen;

(*)

		Free Pascal Compiler version 3.2.2 [2024/05/01] for x86_64
		
		Free to use, as is, experimental , different take on the parameter boilerplate stuff..

		directives:
		https://www.freepascal.org/docs-html/prog/progch1.html

        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        https://www.freepascal.org/advantage.var

(*)


{$IFDEF FPC}
	{$mode objfpc}          (*) directive to be used for defining classes   (*)

	{$LONGSTRINGS ON}       (*) aka {H+}  = ansistrings                     (*)
	{$RANGECHECKS ON}       (*) aka {$R+}                                   (*)
	{$S+}                   (*) stack checking on                           (*)
	{$TYPEDADDRESS ON}      (*) aka {$T+}                                   (*)
{$ELSE}
	{$APPTYPE CONSOLE}
{$ENDIF}

{$MACRO ON}
{$DEFINE crlf   := #13#10 }
{$DEFINE tab    := #9     }
{$DEFINE quot   := #39	  }
{$DEFINE dquot  := #34    }
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined} // Use for variants, complex numbers

USES

	crt,
	Math,
	SysUtils,
	TypeUtils
	;
	
TYPE

	List  	  = array of string ;

// Mod to change printing behaviour of plural
OPERATOR * (const A: char; const B: boolean): char;
	BEGIN	IF B = True THEN Result := A  ;	END;


// Oneline if-then-else
FUNCTION IIF ( Cond: boolean;  A, B: variant ) : variant ;
	BEGIN	IF ( Cond ) THEN IIF := A ELSE IIF := B ;	END ;

	
// Mod to change behaviour, needed in GetPVal
OPERATOR IN (const A: string; const B: string): integer;
	BEGIN	Result := pos( A, B ) ;	END;

// Mod for options
FUNCTION GetPVal ( parm:string; opt:string): integer;

	BEGIN
	
		GetPVal := opt in parm;
		
		IF  GetPVal > 0 THEN
		  GetPVal:= ( StrToIntDef( Copy( parm, Min( High( parm ), GetPVal + 2 ) ).Split(' ')[0], 0 ));
	END;



FUNCTION PickFrom ( S: string ): char;
	BEGIN	PickFrom := S[ math.RandomRange( Low(S), high(S) ) ] ;	END;



(*) MAINLINE (*)

VAR
	L:			  List ;
	_:			string ;
	S:			string ;
	excluding : array of char = ( '|','I','l','1','O','0','5','S','Z','2' ) ;
	numb3rs:	string = '0123456789';
	l3tters:	string = 'abcdefghijklmnopqrstuvwxyz';
	speci4ls:	string = '!"#$%&''()*+,-./:;<=>?@[]^_{|}~';
	j,k:		integer;
	n:			integer =  1;
	w:			integer = 17;
	parm:		string  = '';

BEGIN
	Randomize;

	FOR k := 1 TO paramcount() DO
		parm := parm + paramstr( k ) + ' ' ;

	IF '-h' IN parm > 0 THEN
		BEGIN
		  WriteLn	(  crlf , 'pwgen -[hwren]',		  crlf ) ;
		  WriteLn ( 'Generates random passwords.' , crlf , 'Without options it generates ', n ,' password',  's' * (n > 1),', of width ', w , '.',	crlf ) ;
		  WriteLn ( 'options: -h(elp), -w(idth of password [ 8 to 500 ] ), -r(andom seed), -e(xlude lookalikes), -n(r of passwords [ 1 to 500 ])',  	crlf ) ;
		  WriteLn ( 'ex. :  ./pwgen -n7 -w15 -r17', crlf ) ;
		  Exit();
		END; // IF '-h' IN parm

	n 		  :=  IIF ( GetPVal ( parm, '-n') = 0, 		n,  Min ( 500, Max ( GetPVal ( parm, '-n'), 1) ) ) ;
	w 		  :=  IIF ( GetPVal ( parm, '-w') = 0, 		w,	Min ( 500, Max ( GetPVal ( parm, '-w'), 8) ) ) ;
	RandSeed  :=  IIF ( GetPVal ( parm, '-r') = 0, RandSeed,	GetPVal ( parm, '-r') ) ;

	FOR j := 1 TO n DO

	  BEGIN

		S:='';

		FOR k := 0 TO w DO
		  S := S + PickFrom( numb3rs ) + PickFrom( l3tters ) + PickFrom( speci4ls ) + PickFrom( UpperCase( l3tters ) );

		IF '-e' IN parm > 0 THEN

			BEGIN
					
			    L := S.Split( excluding) ;
					
				FOR _ in L DO
				    S := S + _ ;

			END; // IF '-e' IN parm

			WriteLn( copy( S, math.RandomRange ( Low( S ), High( S ) - w ), w ) );

	END; // FOR j := 1
	
END. (*) Of PROGRAM pwgen.pas (*)

(*)
