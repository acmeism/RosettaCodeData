$$ MODE TUSCRIPT
BUILD X_TABLE blanks = ":': :"

SECTION game
operators="*'/'+'-'(')",numbers=""

LOOP n=1,4
number=RANDOM_NUMBERS (1,9,1)
numbers=APPEND(numbers,number)
ENDLOOP

SET allowed=APPEND (numbers,operators)
SET allowed=MIXED_SORT (allowed)
SET allowed=REDUCE (allowed)
BUILD S_TABLE ALLOWED =*
DATA '{allowed}'

SET checksum=DIGIT_SORT (numbers)

printnumbers=EXCHANGE (numbers,blanks)
printoperat=EXCHANGE (operators,blanks)

PRINT "Your numbers ", printnumbers
PRINT "Use only these operators ", printoperat
PRINT "Enter an expression that equates to 24"
PRINT "Enter 'l' for new numbers"
PRINT "Your 4 digits: ",printnumbers

DO play
ENDSECTION

SECTION check_expr
 SET pos = VERIFY (expr,allowed)
 IF (pos!=0) THEN
  PRINT "wrong entry on position ",pos
  DO play
  STOP
 ELSE
  SET yourdigits   = STRINGS (expr,":>/:")
  SET yourchecksum = DIGIT_SORT (yourdigits)
   IF (checksum!=yourchecksum) THEN
    PRINT/ERROR "wrong digits"
    DO play
    STOP
   ELSE
    CONTINUE
   ENDIF
 ENDIF
ENDSECTION

SECTION play
LOOP n=1,3
ASK   "Expression {n}": expr=""
IF (expr=="l") THEN
RELEASE S_TABLE allowed
PRINT "Your new numbers"
DO game
ELSEIF (expr!="") THEN
DO check_expr
sum={expr}
 IF (sum!=24) THEN
  PRINT/ERROR expr," not equates 24 but ",sum
  CYCLE
 ELSE
  PRINT "BINGO ", expr," equates ", sum
  STOP
 ENDIF
ELSE
 CYCLE
ENDIF
ENDLOOP
ENDSECTION
DO game
