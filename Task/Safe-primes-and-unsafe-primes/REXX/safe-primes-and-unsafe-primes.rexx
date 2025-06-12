-- 12 Apr 2025
include Settings
numeric digits 10

call Time('r')
say 'SAFE AND UNSAFE PRIMES'
say version
say
call Primes 1e8
call FirstSafe
call FirstUnsafe
call CountBoth
say Format(Time('e'),,3) 'seconds'
exit

FirstSafe:
procedure expose flag.
say 'The first 35 safe primes are...'
n = 0
do i = 3 by 2 until n = 35
   if flag.i then do
      j = (i-1)/2
      if flag.j then do
         n = n+1
         call Charout ,Right(i,5)
         if n//10 = 0 then
            say
      end
   end
end
say; say
return

FirstUnsafe:
procedure expose flag.
say 'The first 40 unsafe primes are...'
call charout ,right(2,5); n = 1
do i = 3 by 2 until n = 40
   if flag.i then do
      j = (i-1)/2
      if \ flag.j then do
         n = n+1
         call Charout ,Right(i,5)
         if n//10 = 0 then
            say
      end
   end
end
say
return

CountBoth:
procedure expose flag.
s = 0; u = 1; p = 1
do i = 3 by 2 to 1e8+1
   a = 1'e'p
   if i > a then do
      say s 'safe primes below 10^'p
      say u 'unsafe primes below 10^'p
      say
      p = p+1
   end
   if flag.i then do
      j = (i-1)/2; s = s+(flag.j); u = u+(\ flag.j)
   end
end
return

include Sequences
include Functions
include Constants
include Abend
