-- 23 May 2026
include Setting
numeric digits 21

say 'ESTHETIC NUMBERS'
say version
say
call Task1
call Timer 'R'
call Task2 1000,9999
call Task2 1.0e8,1.3e8
call Timer 'R'
call Generate
call Task3 1.0e8,1.3e8,1
call Task3 1.0e11,1.3e11,0
call Task3 1.0e14,1.3e14,0
call Task3 1.0e17,1.3e17,0
call Task3 1.0e20,1.3e20,0
call Timer 'R'
exit

Task1:
-- Shows ranges Esthetic numbers in bases 2 thru 16
procedure
do base=2 to 16
   n=0; n1=base*4; n2=base*6; d=0
   say 'Brute-force: Base' base 'Index' n1 'thru' n2'...'
   do i=1 until n=n2
      if base=10 then
         j=i
      else
         j=D2n(i,base)
      if Esthetic(j) then do
         n+=1
         if n>=n1 & n<=n2 then do
            d+=1
            call CharOut ,j' '
            if d//20=0 then
               say
         end
      end
   end i
   say; say
end base
return

Task2:
-- Shows range Esthetic numbers in base 10
-- using brute-force algorithm
procedure
arg n1,n2
say 'Brute-force: Base 10 from' n1 'to' n2'...'
n=0
do i=n1 to n2
   if Esthetic(i) then do
      n+=1
      call CharOut ,i' '
      if n//10=0 then
         say
   end
end i
say
say n 'found'
say
return

Esthetic:
-- Is a number Esthetic?
procedure
arg xx
if xx<10 then
   return 1
dig='0123456789ABCDEF'
est=1; a=SubStr(xx,1,1)
do i=2 to Length(xx)
   b=SubStr(xx,i,1)
   if Abs(Pos(a,dig)-Pos(b,dig))<>1 then do
      est=0
      leave
   end
   a=b
end i
return est

Generate:
-- Generate all Esthetic numbers
-- needed for the stretch task and beyond
-- Iterative solution
procedure expose Esth. Wrk1. Wrk2.
say 'Generate up to' Digits() 'digits...'
do i=1 to 9
   Wrk1.i=i; Esth.i=i
end
Wrk1.0=9; n=9
do Digits()-1
   w=0
   do i=1 to Wrk1.0
      a=Wrk1.i; b=Right(a,1)
      if b > 0 then do
         w+=1; Wrk2.w=a||(b-1)
      end
      if b < 9 then do
         w+=1; Wrk2.w=a||(b+1)
      end
   end i
   Wrk2.0=w
   do i=1 to w
      Wrk1.i=Wrk2.i; n+=1; Esth.n=Wrk2.i
   end i
   Wrk1.0=w
end
Esth.0=n
say n 'found'
say
return

Task3:
-- Shows range Esthetic numbers in base 10
-- using the generated array
procedure expose Esth.
arg n1,n2,all
say 'Generated: Base 10 from' n1 'to' n2'...'
i1=0; i2=0
do i=1 to Esth.0
   a=Esth.i
   if a<n1 then
      iterate i
   if i1=0 then
      i1=i
   if a>n2 then do
      i2=i-1
      leave i
   end
end i
n=i2-i1+1
if all then do
   k=0
   do i=i1 to i2
      k+=1
      call CharOut ,Esth.i' '
      if k//5=0 then
         say
   end i
   say
end
else do
   do i=i1 for 5
      call CharOut ,Esth.i' '
   end
   say; say '...'
   do i=i2-4 for 5
      call CharOut ,Esth.i' '
   end
   say
end
say n 'found'
say
return

-- D2n Timer
include Math
