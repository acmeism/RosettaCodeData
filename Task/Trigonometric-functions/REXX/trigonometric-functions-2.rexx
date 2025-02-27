include Settings

say version; say 'Trigonometric functions'; say
s = Copies('-',77); w = 18
call Trigo
call Arcus1
call Arcus2
exit

Trigo:
say s
say 'Deg' Left('Rad',w) Left('Sin(Rad)',w) Left('Cos(Rad)',w) Left('Tan(Rad)',w)
say s
do a = 0 by 5 to 90
   b = Rad(a)
   say Left(a,3) Left(b/1,w) Left(Sin(b)/1,w) Left(Cos(b)/1,w) Left(Tan(b)/1,w)
end
say s
return

Arcus1:
say Left('Arg',4) Left('Arcsin(Arg)',w) Left('Arccos(Arg)',w) Left('Arctan(Arg)',w)
say s
do b = -1 by 0.1 to 1
   say Left(b,4) Left(Arcsin(b)/1,w) Left(Arccos(b)/1,w) Left(Arctan(b)/1,w)
end
say s
return

Arcus2:
say 'Deg' Left('Rad',w) Left('Arcsin(Sin(Rad))',w) Left('Arccos(Cos(Rad))',w) Left('Arctan(Tan(Rad))',w)
say s
do a = 0 by 5 to 90
   b = Rad(a)
   say Left(a,3) Left(b/1,w) Left(Arcsin(Sin(b))/1,w) Left(Arccos(Cos(b))/1,w) Left(Arctan(Tan(b))/1,w)
end
say s
return

include Functions
include Constants
include Abend
