-- 27 Sep 2025
include Setting
numeric digits 100

say 'FIND FIRST AND LAST SET BIT OF A LONG INTEGER'
say version
say
call Task 42,18
call Task 1302,9
exit

Task:
procedure
arg xx,yy
say 'power ' right('decimal',29) right('binary',98) 'msb' 'lsb'
do n=0 to yy
   a=xx**n; b=X2B(D2X(a))+0
   say Left(xx'^'n,6) Right(a,29) Right(b,98) Right(Length(b)-1,3) Right(Pos('1',Reverse(b))-1,3)
end
say
return

include Abend
