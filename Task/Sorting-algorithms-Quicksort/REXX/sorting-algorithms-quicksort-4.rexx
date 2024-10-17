Recursive:
procedure expose stem.
arg l r
m = (l+r)%2; p = stem.m
i = l; j = r
do while i <= j
   do i = i while stem.i < p
   end
   do j = j by -1 while stem.j > p
   end
   if i <= j then do
      t = stem.i; stem.i = stem.j; stem.j = t
      i = i+1; j = j-1
   end
end
if l < j then
   call Recursive l j
if i < r then
   call Recursive i r
return
