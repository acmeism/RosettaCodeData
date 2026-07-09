-- 7 Jul 2026
include Setting
numeric digits 200

SAY 'POLLARD''S RHO ALGORITHM'
say version
say
call TestNumbers
call Selected
call Random ,,12345
call Randomized
exit

TestNumbers:
procedure expose Test.
t='31',
  '4294967213',
  '9759463979',
  '34225158206557151',
  '576460752303423487',
  '147573952589676412927',
  '763218146048580636353',
  '5465610891074107968111136514192945634873647594456118359804135903459867604844945580205745718497'
do i=1 to Words(t)
   Test.i=Word(t,i)
end
Test.0=i-1
return

Selected:
procedure expose Mult. Test. Glob.
call Time('r')
say 'Find a factor for 8 selected numbers...'
do t=1 for Test.0
   n=Test.t
   call Time('r')
   f=Pollardrho(n)
   if f=0 then
      u='failed'
   else
      u=f 'x' n/f
   say Format(Time('e'),4,3)'s' n '('Xpon(n)+1 'digits) =' u
end
say
return

Randomized:
procedure expose Mult. Glob.
say 'Find a factor for 30 random numbers...'
x=0
do until x=30
   n=''
   do Random(1,30)
      n||=Random(9)
   end
   n+=0
   if Pos(Right(n,1),024568) > 0 | Digitsum(n)//3 = 0 then
      iterate
   call Time('r')
   f=Pollardrho(n)
   if f=0 then
      u='failed'
   else
      u=f 'x' n/f
   say Format(Time('e'),4,3)'s' n '('Xpon(n)+1 'digits) =' u
   x+=1
end
say
return

-- Pollardrho Digitsum Xpon
include Math
