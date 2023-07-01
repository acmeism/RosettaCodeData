$$ MODE TUSCRIPT
SECTION check
  IF (n!=1) THEN
   n = STRINGS (n,":>/:")
    LOOP/CLEAR nr=n
     square=nr*nr
     n=APPEND (n,square)
    ENDLOOP
   n=SUM(n)
   r_table=QUOTES (n)
   BUILD R_TABLE/word/EXACT chk=r_table
   IF (seq.ma.chk) THEN
    status="next"
   ELSE
    seq=APPEND (seq,n)
   ENDIF
   RELEASE r_table chk
  ELSE
    PRINT checkednr," is a happy number"
    happynrs=APPEND (happynrs,checkednr)
    status="next"
  ENDIF
ENDSECTION

happynrs=""

LOOP n=1,100
sz_happynrs=SIZE(happynrs)
IF (sz_happynrs==8) EXIT
checkednr=VALUE(n)
status=seq=""
 LOOP
  IF (status=="next") EXIT
  DO check
 ENDLOOP
ENDLOOP
