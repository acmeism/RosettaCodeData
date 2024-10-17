PROGRAM DNABaseCount;

(*)

		Free Pascal Compiler version 3.2.2 [2024/05/01] for x86_64
		
		Free to use, as is, experimental

		directives:
		https://www.freepascal.org/docs-html/prog/progch1.html

        The free and readable alternative at C/C++ speeds
        compiles natively to almost any platform, including raspberry PI *
        Can run independently from DELPHI / Lazarus

        https://www.freepascal.org/advantage.var

(*)


{$IFDEF FPC}
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
{$DEFINE xy     := x * y  }

USES
	crt,
	SysUtils
	;


FUNCTION DnaCount ( S: string; var total: integer; a: char ) : integer;

    BEGIN

        DnaCount := length ( S.Split ( a ) ) - 1 ;

        total := total + Dnacount ;

    END;



FUNCTION Print ( S: string ; start: integer ; len: integer ) : string;

    BEGIN

        Print := '' ;

        FOR start := 0 TO length (S)  DO
            Print := Print + ( copy ( S, start * len + 1, len ) + ' ' );

    END;



VAR
   dna: string =
                'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG' +
                'CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG' +
                'AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT' +
                'GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT' +
                'CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG' +
                'TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA' +
                'TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT' +
                'CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG' +
                'TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC' +
                'GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT' ;

    x           :                                   integer          ;
    y           :                                   integer =     0  ;
    S           :                                   string  = 'ACGT' ;
    base        :                                   char    =    ' ' ;
    total       :                                   integer =     0  ;
    width       :                                   integer =    10  ;


BEGIN

    y:= length( dna ) div width ;

    Writeln ( crlf , crlf , 'Sequence:' , crlf );

    FOR x:= 0 TO ( length( dna ) div y ) - 1    DO
        Writeln ( xy: 3 , ':  ': 3 , Print( copy( dna, xy + 1, y ), 0, width ) );

    Writeln( crlf , crlf , 'Base' , tab , 'Count' , crlf );

    FOR base IN S DO
        Writeln ( base:4, DnaCount( dna, total, base ): width + 4 ) ;

    Writeln ( crlf , crlf , 'Total:', tab, total, crlf );

END. (*) Of PROGRAM DNABaseCount.pas (*)

(*)
