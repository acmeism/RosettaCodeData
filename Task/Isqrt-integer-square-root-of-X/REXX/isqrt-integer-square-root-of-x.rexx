-- 28 Jul 2025
include Settings

say 'ISQRT (INTEGER SQUARE ROOT)'
say version
say
call Task1 65
call Task2 1,2,73,'Q'
call Task2 123,1,123,'Q'
call Task2 123,1,123,'I'
call Task2 123,1,123,'F'
call Task2 1234,1,1234,'Q'
call Task2 1234,1,1234,'I'
call Task2 1234,1,1234,'F'
call Task2 12345,1,12345,'Q'
call Task2 12345,1,12345,'I'
call Task2 12345,1,12345,'F'
exit

Task1:
procedure
arg xx
call time('r')
say 'Integer square root for n = 0...'xx
do n = 0 to xx
   call Charout ,QuadraticResidue(n)' '
end
say
call Timer
return

Task2:
procedure expose Memo.
arg xx,yy,zz,mm
call Time('r')
select
   when mm = 'Q' then
      t = 'Quadratic residue'
   when mm = 'I' then
      t = 'Integer division'
   when mm = 'F' then
      t = 'Floating square root'
end
say Right('n',5) Left('7^n',40) Left('Isqrt(7^n) using' t,60)
numeric digits zz
do n = xx by yy to zz
   p = 7**n+0
   pl = Length(p)
   select
      when mm = 'Q' then
         r = QuadraticResidue(p)
      when mm = 'I' then
         r = WikiPedia(p)
      when mm = 'F' then
         r = Std(Floor(Sqrt(p))/1)
   end
   rl = Length(r)
   if pl > 20 then
      p = Left(p,10)'...'Right(p,10) '['pl 'digits]'
   else
      p = p '['pl 'digits]'
   if rl > 20 then
      r = Left(r,10)'...'Right(r,10) '['rl 'digits]'
   else
      r = r '['rl 'digits]'
   say Right(n,5) Left(p,40) Left(r,40)
end
call Timer
return

QuadraticResidue:
procedure
arg xx
-- First power of 4 > x
q = 1
do until q > xx
   q = q*4
end
-- Iterate back to 1 using integer division
zz = 0
do while q > 1
   q = q%4; t = xx-zz-q; zz = zz%2
   if t >= 0  then do
      xx = t; zz = zz+q
   end
end
return zz

WikiPedia:
procedure
arg xx
-- Reduce argument to 1...100
e = Xpon(xx)%2; a = -2*e; a = xx'E'a
-- First guess and undo reduce
select
   when a < 4 then
      zz = 2'E'e
   when a < 9 then
      zz = 3'E'e
   when a < 16 then
      zz = 4'E'e
   when a < 25 then
      zz = 5'E'e
   when a < 36 then
      zz = 6'E'e
   when a < 49 then
      zz = 7'E'e
   when a < 64 then
      zz = 8'E'e
   when a < 81 then
      zz = 9'E'e
   otherwise
      zz = 10'E'e
end
-- Loop by integer division
z = (zz+xx%zz)%2
do while z < zz
   zz = z; z = (zz+xx%zz)%2
end
return zz

include Math
