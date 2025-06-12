-- 8 May 2025
include Settings

say 'MAGIC CONSTANT'
say version
say
numeric digits 23
call Getmagics 6e8
call Task1
call Task2
call Task3
exit

Getmagics:
call Time('r')
arg xx
say 'Get magic constants up to' xx
say Magics(xx) 'collected'
say Format(Time('e'),,3) 'seconds'
say
return

Task1:
call Time('r')
say 'The first 25 magic constants are'
do i = 3 to 28
   call Charout ,magi.i' '
end
say
say Format(Time('e'),,3) 'seconds'
say
return

Task2:
call Time('r')
say 'The 1000th magic constant is'
say magi.1002
say Format(Time('e'),,3) 'seconds'
say
return

Task3:
call Time('r')
say 'Smallest magic square with constant > 10^n is'
say Left('n',5) Right('order',8)
say '--------------'
e = 1
do i = 3 to 6e7
   if Magic(i) > 1'E'e then do
      say Left('10^'e,5) Right(i,8)
      e = e+1
   end
end
say '--------------'
say Format(Time('e'),,3) 'seconds'
say
return

include Functions
include Sequences
include Numbers
include Abend
