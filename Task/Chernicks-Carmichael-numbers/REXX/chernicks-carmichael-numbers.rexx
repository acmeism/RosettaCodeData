include Settings

say version; say 'Chernick''s Carmichael numbers'; say
numeric digits 80
say Copies('-',80)
say 'n   m(n) a(n)'
say Copies('-',80)
do n = 3 to 9
   mp = 1
   if n > 4 then
      mp = 2**(n-4)
   if n > 5 then
      mp = mp*5
   k = 0
   do x = 1
      k = k+1; m = mp*k; f.1 = 6*m+1
      if \ IsPrime(f.1) then
         iterate x
      f.2 = 12*m+1
      if \ IsPrime(f.2) then
         iterate x
      f = 2
      do i = 1 to n-2
         f = f+1; f.f = 2**i*9*m+1
         if \ IsPrime(f.f) then
            iterate x
      end
      a = 1
      do i = 1 to f
         a = a*f.i
      end
      say n Right(m,6) a
      leave x
   end
end
say Copies('-',80)
say Format(Time('e'),3,3) 'seconds'
say
exit

include Numbers
include Functions
include Abend
