-- 11 Sep 2025
include Setting

say 'FUNCTION DEFINITION'
say version
say
xx=0; yy=0; rr=0
say 'xx =' xx 'yy =' yy  'rr =' rr
say 'Multiply1(2,3)' '=' Multiply1(2,3)
say 'xx =' xx 'yy =' yy  'rr =' rr
say 'Multiply2(3,5)' '=' Multiply2(3,5)
say 'xx =' xx 'yy =' yy  'rr =' rr
xx=5; yy=7
say 'xx =' xx 'yy =' yy  'rr =' rr
say 'Multiply3(5,7)' '=' Multiply3()
say 'xx =' xx 'yy =' yy  'rr =' rr
exit

Multiply1:
procedure
arg xx,yy
rr=xx*yy
return rr

Multiply2:
arg xx,yy
rr=xx*yy
return rr

Multiply3:
rr=xx*yy
return rr

include Math
