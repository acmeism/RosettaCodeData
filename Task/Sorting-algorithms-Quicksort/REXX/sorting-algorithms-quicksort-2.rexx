Elegant:
procedure expose stem.
push 1 stem.0
do while queued() > 0
   pull l r
   if l < r then do
      m = (l+r)%2; p = stem.m; i = l-1; j = r+1
      do forever
         do until stem.j <= p
            j = j-1
         end
         do until stem.i >= p
            i = i+1
         end
         if i < j then do
            t = stem.i; stem.i = stem.j; stem.j = t
         end
         else
            leave
      end
      push l j; push j+1 r
   end
end
return
