-- 12 Apr 2025
include Settings

call Time('r')
say 'SUCCESSIVE PRIME DIFFERENCES'
say version
say
call Primes 1e6
say 'For the' prim.0 'primes up to 1 million...'
say
call Task 1
call Task 2
call Task 2,2
call Task 2,4
call Task 4,2
call Task 2,4,6
call Task 2,4,6,8
call Task 2,4,6,8,10
call Task 2,4,6,8,10,12
call Task 2,4,6,8,10,12,14
call Task 32,16,8,4,2
say Format(Time('e'),,3) 'seconds'
exit

Task:
procedure expose prim.
diffs = ''; first = ''; last = ''
do i = 1 to Arg()
   diffs = diffs||Arg(i)' '
end
count = 0
do i = 1 to prim.0-Arg()
   a = prim.i; work = a; k = i
   do j = 1 to Arg()
      k = k+1; b = prim.k
      if b-a <> Arg(j) then
         iterate i
      work = work b; a = b
   end
   count = count+1
   if first = '' then
      first = work
   last = work
end
say 'Differences ' diffs
say 'First group ' first
say 'Last group  ' last
say 'Groups found' count
say
return

include Sequences
include Functions
include Abend
