include Settings

say version; say 'Cuban primes'; say
numeric digits 20
call ShowCubans 1,200,8
call ShowCubans 100000,,13
say
say Format(Time('e'),,3) 'seconds'
exit

ShowCubans:
procedure expose glob.
arg x,y,z
if y = ''
   then y = x
if x = y then
   say 'Cuban prime no' x
else
   say 'Cuban primes nos' x 'thru' y
i = 2; a = 1; b = 8; n = 0
do while n < y
   v = b-a
   if Prime(v) then do
      n = n+1
      if n >= x then do
         call Charout ,Right(v,z)
         if n//10 = 0 then
            say
      end
   end
   a = b; i = i+1; b = i*i*i
end
say
return

include Numbers
include Functions
include Abend
