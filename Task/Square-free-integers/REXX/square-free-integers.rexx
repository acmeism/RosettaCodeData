include Settings

say 'SQUARE-FREE INTEGERS - 6 Mar 2025'
say version
say
numeric digits 5
call Show 1,145
numeric digits 15
call Show 1000000000000,1000000000145
numeric digits 10
call Count1 1000000
call Count2 1000000
exit

Show:
call Time('r')
arg xx,yy
say 'Square-free integers between' xx 'and' yy
r = Length(yy)+1; n = 0
do i = xx to yy
   if Squarefree(i) then do
      n = n+1
      call Charout ,Right(i,r)
      if n//10 = 0 then
         say
   end
end
say
say Format(Time('e'),,3) 'seconds'
say
return

Count1:
call Time('r')
arg xx
say 'Number of square-free integers <= 10^n'
say 'Direct method'
say '--------------'
say Left('n',4) Right('count',6)
say '--------------'
n = 0; e = 1
do i = 1 to xx
   if i >= 1'E'e then do
      say Left('10^'e,5) Right(n,8)
      e = e+1
   end
   if Squarefree(i) then
      n = n+1
end
say '--------------'
say Format(Time('e'),,3) 'seconds'
say
return

Count2:
call Time('r')
arg xx
call Squarefrees xx
say 'Number of square-free integers <= 10^n'
say 'Sieve method'
say '--------------'
say Left('n',4) Right('count',6)
say '--------------'
n = 0; e = 1
do i = 1 to xx
   if i >= 1'E'e then do
      say Left('10^'e,5) Right(n,8)
      e = e+1
   end
   if squa.flag.i then
      n = n+1
end
say '--------------'
say Format(Time('e'),,3) 'seconds'
return

include Numbers
include Sequences
include Functions
include Abend
