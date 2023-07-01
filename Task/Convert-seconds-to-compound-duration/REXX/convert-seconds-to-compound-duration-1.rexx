/* REXX ---------------------------------------------------------------
* Format seconds into a time string
*--------------------------------------------------------------------*/
Call test 7259    ,'2 hr, 59 sec'
Call test 86400   ,'1 d'
Call test 6000000 ,'9 wk, 6 d, 10 hr, 40 min'
Call test 123.50  ,'2 min, 3.5 sec'
Call test 123.00  ,'2 min, 3 sec'
Call test 0.00    ,'0 sec'
Exit

test:
  Parse arg secs,xres
  res=sec2ct(secs)
  Say res
  If res<>xres Then Say '**ERROR**'
  Return

sec2ct:
Parse Arg s
/*
m=s%60; s=s//60
h=m%60; m=m//60
d=h%24; h=h//24
w=d%7;  d=d//7
*/
If s=0 Then Return '0 sec'
Parse Value split(s,60) with m s
Parse Value split(m,60) with h m
Parse Value split(h,24) with d h
Parse Value split(d, 7) with w d
ol=''
If w>0 Then ol=ol w 'wk,'
If d>0 Then ol=ol d 'd,'
If h>0 Then ol=ol h 'hr,'
If m>0 Then ol=ol m 'min,'
If s>0 Then ol=ol (s/1) 'sec'
ol=strip(ol)
ol=strip(ol,,',')
Return ol

split: Procedure
  Parse Arg what,how
  a=what%how
  b=what//how
  Return a b
