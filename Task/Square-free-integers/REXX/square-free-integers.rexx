-- 16 May 2026
include Setting

say 'SQUARE-FREE INTEGERS'
say version
say
numeric digits 5
call Show 1,145
call Timer 'R'
numeric digits 15
call Show 1000000000000,1000000000145
call Timer 'R'
numeric digits 10
call Count1 1000000
call Timer 'R'
call Count2 1000000
call Timer 'R'
exit

Show:
arg xx,yy
say 'Square-free integers between' xx 'and' yy
r=Length(yy)+1; n=0
do i = xx to yy
   if Squarefree(i) then do
      n+=1
      call Charout ,Right(i,r)
      if n//10=0 then
         say
   end
end
say
return

Count1:
arg xx
say 'Number of square-free integers <= 10^n'
say 'Direct method'
say '--------------'
say Left('n',4) Right('count',9)
say '--------------'
n=0; e=1
do i=1 to xx
   if i>=1'E'e then do
      say Left('10^'e,5) Right(n,8)
      e+=1
   end
   if Squarefree(i) then
      n+=1
end
say '--------------'
return

Count2:
arg xx
call SquarefreeS xx
say 'Number of square-free integers <= 10^n'
say 'Sieve method'
say '--------------'
say Left('n',4) Right('count',6)
say '--------------'
n=0; e=1
do i=1 to xx
   if i>=1'E'e then do
      say Left('10^'e,5) Right(n,8)
      e+=1
   end
   if flag.i then
      n+=1
end
say '--------------'
return

-- Squarefree SquarefreeS Timer
include Math
