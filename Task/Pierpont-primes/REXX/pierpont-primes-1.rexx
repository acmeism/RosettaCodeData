-- 11 Apr 2025
include Settings

call Time('r')
say 'PIERPOINT PRIMES (BRUTE FORCE)'
say version
say
numeric digits 40
call GetPierpont
call Sort 'firs.'
call Sort 'seco.'
call ShowPierpont
say Format(Time('e'),,3) 'seconds'; say
exit

GetPierpont:
procedure expose firs. glob. seco.
say 'Get Pierpont primes...'
n1 = 0; firs. = 0; n2 = 0; seco. = 0
p = 0; m = 1e40
do u = 0 to 120
   a = 2**u
   if a > m then
      leave u
   do v = 0 to 80
      b = 3**v
      if b > m then
         iterate u
      px = a*b
      if px > m then
         iterate v
      p1 = px+1; p = p+1
      if Prime(p1) then do
         n1 = n1+1; firs.n1 = p1
      end
      p2 = px-1; p = p+1
      if Prime(p2) then do
         n2 = n2+1; seco.n2 = p2
      end
   end
end
firs.0 = n1; seco.0 = n2
say p 'primality tests performed'
say n1 'numbers of the first kind generated'
say n2 'numbers of the second kind generated'
say
return

ShowPierpont:
procedure expose firs. seco.
say 'Pierpont primes of the first kind nos 1 thru 50...'
do i = 1 to 50
   call Charout, Right(firs.i,9)
   if i//10 = 0 then
      say
end
say
say 'Pierpont primes of the second kind nos 1 thru 50...'
do i = 1 to 50
   call Charout, Right(seco.i,9)
   if i//10 = 0 then
      say
end
say
say 'Pierpont prime of the first kind no 250...'
say firs.250
say
say 'Pierpont prime of the second kind no 250...'
say seco.250
say
return

include Numbers
include Functions
include Helper
include Abend
