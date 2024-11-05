include Settings

say version; say 'Home Primes'; say
numeric digits 22
do i = 1 to 48
   call Home i
end
exit

Home:
procedure expose fact. glob. work.
arg xx
call Time('r')
yy = xx/1
/* Collect chain */
n = 0
do while Factors(yy) > 1
   n = n+1; work.n = yy; yy = ''
   do i = 1 to fact.0
      yy = yy||fact.factor.i
   end
end
/* Show results */
if n = 0 then
   call Charout ,'HP'xx '= '
else do
   do i = 1 to n
      call Charout ,'HP'work.i'('n-i+1') = '
   end
end
call Charout ,yy
say
say Time('e')/1 'seconds'
say
return

include Abend
include Functions
include Numbers
include Sequences
