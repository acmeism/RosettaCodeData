include Settings

say 'SEMIPRIME - 4 Mar 2025'
say version
say
numeric digits 100
call Sequence 1,200
call Sequence 100001,100200
call Sequence 1000000001,1000000200
call Sequence 158456325028528675187087900601,158456325028528675187087900660
exit

Sequence:
arg xx,yy
say 'Semiprimes between' xx 'to' yy
if yy = '' then
   yy = xx
l = length(yy)+1
n = 0
do i = xx to yy
   if Semiprime(i) then do
      n = n+1
      call Charout ,right(i,l)
      if n//5 = 0 then
         say
   end
end
say
say Format(Time('e'),,3) 'seconds'
say
return

include Functions
include Numbers
include Sequences
include Abend
