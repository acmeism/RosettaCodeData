$$ MODE TUSCRIPT
numbers=RANDOM_NUMBERS (1,9,9),nr=0

SECTION check
LOOP o,n=numbers
 IF (n!=o) THEN
  DO PRINT
  EXIT
 ELSEIF (n==9&&o==9) THEN
  DO PRINT
  PRINT " You made it ... in round ",r
  STOP
 ELSE
  CYCLE
 ENDIF
ENDLOOP
ENDSECTION

SECTION print
  PRINT numbers
ENDSECTION


DO PRINT
LOOP r=1,14
IF (nr>=0&&nr<10) THEN
  ASK "Reverse - how many?": nr=""
  i=""
  LOOP n=1,nr
   i=APPEND(i,n)
  ENDLOOP
  numbers   =SPLIT (numbers)
  reverse_nr=SELECT (numbers,#i,keep_nr), reverse_nr=REVERSE(reverse_nr)
  numbers   =APPEND (reverse_nr,keep_nr), numbers   =JOIN   (numbers)
  DO check
ENDIF
ENDLOOP
