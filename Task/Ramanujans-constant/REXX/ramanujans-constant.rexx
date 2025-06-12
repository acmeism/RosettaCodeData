include Settings

say 'RAMANUJAN''S CONSTANT - 6 Mar 2025'
say version
say
call Formula
call Heegner
exit

Formula:
call time('r')
say 'Accurate to 100 digits'
numeric digits 100
say Exp(Pi()*Sqrt(163))
say Format(Time('e'),,3) 'seconds'
say
return

Heegner:
call time('r')
say 'Heegner numbers with differences'
numeric digits 33
h = '19 43 67 163'
do i = 1 to Words(h)
   w = Word(h,i); a = Exp(Pi()*Sqrt(w)); b = Round(a,0)
   say Right(w,3) Left(a,34) Right(Std(Round(a-b,12)),15)
end
say Format(Time('e'),,3) 'seconds'
return

include Constants
include Functions
include Abend
