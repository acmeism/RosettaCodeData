-- 8 May 2025
include Settings

say 'PARTITION AN INTEGER X INTO N PRIMES'
say version
say
call GetPrimes 100000
call ShowPartition 99809,1
call ShowPartition 18,2
call ShowPartition 19,3
call ShowPartition 20,4
call ShowPartition 2017,24
call ShowPartition 22699,1
call ShowPartition 22699,2
call ShowPartition 22699,3
call ShowPartition 22699,4
call ShowPartition 40355,3
exit

GetPrimes:
procedure expose prim.
arg xx
call Time('r')
say 'Get primes up to' xx'...'
call Primes xx
say Format(Time('e'),,3) 'seconds'; say
return

ShowPartition:
procedure expose prim. work.
arg xx,yy
call Time('r')
s = 0
do i = 1 to yy
   work.i = i
end
s = Sumwork(yy)
do z = 1
   select
      when s = xx then
         leave z
      when s < xx then do
         work.yy = work.yy+1
         s = Sumwork(yy)
      end
      when s > xx then do
         do i = yy by -1 to 2 while s > xx
            i1 = i-1; a = work.i1+1
            if prim.a > xx then
               leave z
            work.i1 = a
            do j = i to yy
               a = a+1; work.j = a
            end
            s = Sumwork(yy)
         end
      end
   end
end
if s = xx then do
   p = work.1; z = prim.p
   do i = 2 to yy
      p = work.i; z = z'+'prim.p
   end
end
else do
   z = 'not possible'
end
say xx 'partitioned into' yy 'primes is' z
say Format(Time('e'),,3) 'seconds'; say
return

Sumwork:
procedure expose prim. work.
arg yy
s = 0
do i = 1 to yy
   a = work.i; p = prim.a; s = s+p
end
return s

include Sequences
include Functions
include Constants
include Abend
