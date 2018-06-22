: BEGIN-COLUMN ." <td>" ;
: END-COLUMN   ." </td>" ;

: BEGIN-ROW ." <tr>" BEGIN-COLUMN ;
: END-ROW END-COLUMN ." </tr>" CR ;

: CSV2HTML
	." <table>" CR BEGIN-ROW
	BEGIN KEY DUP #EOF <> WHILE
		CASE
			      10 OF END-ROW BEGIN-ROW ENDOF
			[CHAR] , OF END-COLUMN BEGIN-COLUMN ENDOF
	                [CHAR] < OF ." &lt;" ENDOF
			[CHAR] > OF ." &gt;" ENDOF
			[CHAR] & OF ." &amp;" ENDOF
			DUP EMIT
		ENDCASE
	REPEAT
	END-ROW ." </table>" CR
;

CSV2HTML BYE
