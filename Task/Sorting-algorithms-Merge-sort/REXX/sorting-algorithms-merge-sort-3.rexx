include Settings

say 'MERGE SORT - 4 Mar 2025'
say version
say
call Generate
call Show
call Mergesort 1,n
call Show
exit

Generate:
call Random,,12345
n = 10
do i = 1 to n
   stem.i = Random()
end
stem.0 = n
return

Show:
do i = 1 to n
   say right(i,2) right(stem.i,3)
end
say
return

Mergesort:
procedure expose stem. work.
arg b,e
if e-b < 1 then
   return
if e-b = 1 then do
   if stem.b > stem.e then do
      t = stem.b; stem.b = stem.e; stem.e = t
   end
   return
end
m = (b+e)%2
call Mergesort b,m
call Mergesort m+1,e
call Merger b,m,e
return

Merger:
procedure expose stem. work.
arg b,m,e
i = b; j = m+1; k = b
do while i <= m | j <= e
   select
      when i <= m & j <= e then do
         if stem.i <= stem.j then do
            work.k = stem.i; i = i+1
         end
         else do
            work.k = stem.j; j = j+1
         end
         k = k+1
      end
      when i<=m then do
         work.k = stem.i; i = i+1; k = k+1
      end
      otherwise do
         work.k = stem.j; j = j+1; k = k+1
      end
   end
end
do i = b to e
   stem.i = work.i
end
return

include Abend
