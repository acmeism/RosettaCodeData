-- 22 Mar 2025
include Settings

say 'CATALAN NUMBERS'
say version
say
call GetCatalan 15
call First 15
call GetCatalan 10000
call CalcCatalan 1000000,16
exit

GetCatalan:
procedure expose cata.
call Time('r')
arg xx
say 'Get Catalan numbers up to the' xx'th with full precision...'
call Catalans(-xx-1)
say Format(Time('e'),,3) 'seconds'; say
return

First:
procedure expose cata.
call Time('r')
arg xx
say 'The first' xx 'Catalan numbers...'
do i = 0 to xx-1
   say 'C['i'] =' cata.i
end
say Format(Time('e'),,3) 'seconds'; say
return

CalcCatalan:
procedure expose cata.
call Time('r')
arg xx,yy
say 'Calculate Catalan('xx') with' yy 'digits precision...'
numeric digits yy
say catalann(xx)+0
say Format(Time('e'),,3) 'seconds'; say
return

include Sequences
include Numbers
include Functions
include Constants
include Abend
