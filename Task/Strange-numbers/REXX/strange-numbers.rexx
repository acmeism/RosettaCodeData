-- 13 Jun 2026
include Setting
numeric digits 20

call Time('r')
say 'STRANGE NUMBERS'
say version
say
call Task
call Stretch
call Timer
exit

Task:
procedure
say 'Strange numbers in the range 100 to 500...'
n = 0
do i = 100 to 500
   if Strange(i) then do
      n = n+1
      call Charout ,i' '
      if n//10 = 0 then
         say
   end
end
say
say n 'found'
say
return

Strange:
procedure
arg xx
if xx < 10 then
   return 0
do i = 1 to Length(xx)-1
   if Pos(Abs(Substr(xx,i,1)-Substr(xx,i+1,1)),'014689') > 0 then
      return 0
end
return 1

Stretch:
procedure expose digs. Wrk1. Wrk2.
say 'Strange numbers beginning with 1...'
digs.0 = 2 3 5 7; digs.1 = 3 4 6 8; digs.2 = 0 4 5 7 9; digs.3 = 0 1 5 6 8; digs.4 = 1 2 6 7 9
digs.5 = 0 2 3 7 8; digs.6 = 1 3 4 8 9; digs.7 = 0 2 4 5 9; digs.8 = 1 3 5 6; digs.9 = 2 4 6 7
do d =  2 to 12
   Wrk1.0 = 1; Wrk1.1 = 1; n = 1
   do i = 2 to d
      Wrk2.0 = 0
      do j = 1 to Wrk1.0
         a = Wrk1.j
         do k = 1 to Words(digs.a)
            b = Word(digs.a,k); Wrk2.0 = Wrk2.0 + 1; c = Wrk2.0; Wrk2.c = b
         end
      end
      do j = 1 to Wrk2.0
         Wrk1.j = Wrk2.j
      end
      Wrk1.0 = Wrk2.0; n = Wrk1.0
   end
   say n 'found with' d 'digits'
end
say
return

-- Timer
include Math
