Main:
call Generate
call Show
call Heapsort
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

HeapSort:
procedure expose stem.
n = stem.0
if n < 2 then
   return
n = stem.0; l = (n%2)+1; s = n
do while 1
   if l > 1 then do
      l = l-1; r = stem.l
   end
   else do
      r = stem.s; stem.s = stem.1; s = s-1
      if s = 1 then do
         stem.1 = r
         leave
      end
   end
   i = l; j = l*2
   do while j <= s
      if j < s then do
         k = j+1
         if stem.j < stem.k then
            j = j+1
      end
      if r < stem.j then do
         stem.i = stem.j; i = j; j = j+i
      end
      else
         j = s+1
   end
   stem.i = r
end
return
