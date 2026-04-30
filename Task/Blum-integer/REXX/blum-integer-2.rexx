-- 28 Aug 2025
include Setting
arg count
if count = '' then
   count = 400000
threshold=25*count

say 'BLUM INTEGER'
say version
say
say 'Parameters...'
say 'Threshold' threshold 'Count' count
say
say 'Collect primes...'
say Primes(threshold) 'found'; say
say 'Filter primes 3 modulo 4...'
say Filter3Mod4() 'found'; say
say 'Generate Blum integers...'
say GenerateBlum(threshold) 'found'; say
say 'Blum integers...'; say
call Results threshold,count
call Timer
exit

Filter3Mod4:
procedure expose Prim.
n=0
do i = 1 to Prim.0
   if Prim.i//4 = 3 then
      n=n+1
   else
      Prim.i=0
end
return n

GenerateBlum:
procedure expose Prim. Blum.
arg threshold
Blum.=0; n=0
do i = 1 to Prim.0
   if Prim.i <> 0 then do
      do j = i+1 to Prim.0
         if Prim.j <> 0 then do
            p=Prim.i*Prim.j
            if p > threshold then
               leave j
            n=n+1; Blum.p=1
         end
      end
   end
end
return n

Results:
procedure expose Blum.
arg threshold,count
n=0; digs.=0
do i = 5 by 4 to threshold
   if \ Blum.i then
      iterate i
   n=n+1
   if n > count then
      leave i
   d=Right(i,1); digs.d=digs.d+1
   if n < 51 then do
      if n = 1 then
         say 'The first 50 are'
      call CharOut ,Right(i,4)
      if n//10 = 0 then
         say
      if n = 50 then
         say
      iterate i
   end
   if n = 26828 | n//100000 = 0 then
      say 'The' n'th is' i
   if n = count then do
      say
      say 'Percent distribution of the first' count
      do i = 1 to 9
         if digs.i > 0 then
            say format(digs.i*100/count,2,3)'% ends in' i
      end
   end
end
say
return 0

include Math
