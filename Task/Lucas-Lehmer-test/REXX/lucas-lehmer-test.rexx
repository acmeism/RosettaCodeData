include Settings
numeric digits 5000

say 'LUCAS-LEHMER TEST - 10 Mar 2025'
say version
say
call LucasLehmer
call MillerRabin
exit

LucasLehmer:
say 'Lucas-Lehmer'
call time('r')
do i = 3 by 2 to 1279
   if Prime(i) then
      call LL i
end
say '...'
t = '2203 2281 3217 4253 4423'
do w = 1 to Words(t)
   call LL Word(t,w)
end
say Format(Time('e'),,3) 'seconds'; say
return

LL:
arg xx
d = Length(2**xx-1)
if Primell(xx) then
   say Left('M'xx,5) '('Right(d,4) 'digits) is Prime' Time('e')/1's'
return

MillerRabin:
say 'Miller-Rabin'
call time('r')
do i = 3 by 2 to 1279
   if Prime(i) then
      call MR i
end
say '...'
t = '2203 2281 3217 4253 4423'
do w = 1 to Words(t)
   call MR Word(t,w)
end
say Format(Time('e'),,3) 'seconds'; say
exit

MR:
arg xx
m = 2**xx-1
d = Length(m)
if Prime(m) then do
   if d < 26 then
      a = 'sure'
   else
      a = 'probable'
   say Left('M'xx,5) '('Right(d,4) 'digits) is' a 'Prime' Time('e')/1's'
end
return

include Numbers
include Functions
include Abend
