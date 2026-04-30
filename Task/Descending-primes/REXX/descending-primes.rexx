-- 21 Feb 2026
include Setting

say 'DESCENDING PRIMES'
say version
say
say Collect() 'found'; say
call Show
call Timer
exit

Collect:
procedure expose Prim.
say 'Collect descending primes...'
Prim.=0; n=0; a='1 2 3 4 5 6 7 8 9'
do 9
   b=''
   do i = 1 to Words(a)
      w=Word(a,i)
      if Prime(w) then do
         n=n+1; Prim.n=w
      end
      do j = Right(w,1)-1 by -1 to 1
         b=b w||j
      end
   end
   a=b
end
Prim.0=n
call SortSt 'Prim.'
return n

Show:
procedure expose Prim.
say 'All descending primes below 1,000,000,000'
do i = 1 to Prim.0
   call CharOut ,Right(Prim.i,10)
   if i//10 = 0 then
      say
end
say
return 0

-- Prime; SortSt; Timer
include Math
