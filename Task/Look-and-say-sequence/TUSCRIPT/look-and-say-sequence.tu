$$ MODE TUSCRIPT,{}
num=1,say=""
 LOOP look
  digits=STRINGS (num," ? ")
  digitgrouped=ACCUMULATE (digits,howmany)
   LOOP/CLEAR  h=howmany,digit=digitgrouped
    say=JOIN (say,"",h,digit)
   ENDLOOP
  PRINT say
  num=VALUE(say),say=""
  IF (look==14) EXIT
 ENDLOOP
