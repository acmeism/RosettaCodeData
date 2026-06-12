-- 23 May 2026
include Setting
numeric digits 300

say 'GENERALIZED FLOATING POINT ADDITION'
say version
say
call Task
exit

Task:
say '  N  Dec Base 62'
n=-7; a=12345679; e=63
do until n>21
   b=a'E'e; c=0
   do 81
      c+=b
   end
   d=1'E'e
   say Right(n,3) Sci(c+d) D2n(c+d,62)
   n+=1; a='123456790'a; e-=9
end
return

-- D2n Sci
include Math
