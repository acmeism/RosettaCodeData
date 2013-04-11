DIV(A,B) ;Divide A by B, and watch for division by zero
 ;The ANSI error code for division by zero is "M9".
 ;$ECODE errors are surrounded by commas when set.
 NEW $ETRAP
 SET $ETRAP="GOTO DIVFIX^ROSETTA"
 SET D=(A/B)
 SET $ETRAP=""
 QUIT D
DIVFIX
 IF $FIND($ECODE,",M9,")>1 WRITE !,"Error: Division by zero" SET $ECODE="" QUIT ""
 QUIT "" ; Fall through for other errors
