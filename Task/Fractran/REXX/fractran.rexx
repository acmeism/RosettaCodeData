include Settings

say version; say 'Fractan'; say
parse arg n','t
if n = '' then
   n = 2
if t = '' then
   t = 100
numeric digits 200
call Fractions
call Task
call Powers
call Extra
exit

Fractions:
call Time('r')
say 'Save fractions...'
l = '17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1'
n. = 0; d. = 0; w = Words(l)
do i = 1 to w
   a = Word(l,i); parse var a n.i'/'d.i
end
say Format(Time('e'),,3) 'seconds'; say
return

Task:
call Time('r')
say 'First' t 'terms of the sequence:'
do i = 2 to t
   do j = 1 to w
      if \ Integer(n/d.j) then
         iterate
      call CharOut ,Right(n,9)
      if i//10 = 0 then
         say
      n = n%d.j*n.j
      leave j
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

Powers:
call Time('r')
say 'Flag powers of 2...'
p. = 0; e. = 0
do i = 2 to 100
   a = 2**i; p.a = 1; e.a = i
end
say Format(Time('e'),,3) 'seconds'; say
return

Extra:
call Time('r')
say 'Prime numbers:'
n = 2; p = 0
do i = 2 to 1300000
   do j = 1 to w
      if \ Integer(n/d.j) then
         iterate j
      if p.n then do
         p = p+1
         say Right(p,2) ' Term' Right(i,7) Left('= 2^'e.n,7) 'Prime' Right(e.n,2) 'found'
      end
      n = n%d.j*n.j
      leave j
   end
end
say Format(Time('e'),,3) 'seconds'; say
return

include Functions
include Abend
