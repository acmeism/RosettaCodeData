-- 24 Aug 2025
include Setting

call Time('r')
say 'STRANGE UNIQUE PRIME TRIPLETS'
say version
say
call Primes 100000
call Task 30
call Task -1000
call Task -10000
say Format(Time('e'),,3) 'seconds'; say
exit

Task:
procedure expose prim. flag.
arg xx
v = (xx>0); xx = Abs(xx)
say 'Strange unique prime triplets below' xx'...'
do m = 1 until prim.m > xx
end
m = m-1; n = 0
do i = 1 to m-2
   c = prim.i
   do j = i+1 to m-1
      d = prim.j; f = c+d
      do k = j+1 to m
         e = prim.k; s = f+e
         if flag.s then do
            n = n+1
            if v then do
               call Charout ,Left('['c'+'d'+'e' = 's']',17)
               if n//5 = 0 then
                  say
            end
         end
      end
   end
end
if v then
   say
say n 'found'
say
return

include Math
