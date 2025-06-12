-- 22 Mar 2025
include Settings

say 'HUMBLE NUMBERS'
say version
say
call Humbles 50
call ShowFirstN 50
call Humbles 10000000
call ShowDistribution
say Time('e')/1 'seconds'
exit

ShowFirstN:
procedure expose humb.
arg xx
xx = xx/1
say 'First' xx 'humble numbers are'
do i = 1 to xx
   call Charout ,Right(humb.i,4)
   if i//10 = 0 then
      say
end
say
return

ShowDistribution:
procedure expose humb.
say 'Digit distribution for the first' humb.0 'humble numbers'
d. = 0
do i = 1 to humb.0
   l = Length(humb.i); d.l = d.l + 1; d.0 = Max(l,d.0)
end
l = Copies('-',17)
say l
say 'Dg  Count     Cum'
say l
c = 0
do i = 1 to d.0-1
   c = c + d.i
   say Right(i,2) Right(d.i,6) Right(c,7)
end
say l
return

include Abend
include Functions
include Sequences
