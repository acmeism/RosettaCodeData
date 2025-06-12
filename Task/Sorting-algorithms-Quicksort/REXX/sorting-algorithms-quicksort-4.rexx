Optimized:
procedure expose stem.
n = stem.0; s = 1; sl.1 = 1; sr.1 = n
do until s = 0
   l = sl.s; r = sr.s; s = s-1
   do until l >= r
      if r-l < 11 then do
         do i = l+1 to r
            a = stem.i
            do j=i-1 by -1 to l while stem.j > a
               k = j+1; stem.k = stem.j
            end
            k = j+1; stem.k = a
         end
         if s = 0 then
            leave
         l = sl.s; r = sr.s; s = s-1
      end
      else do
         m = (l+r)%2
         if stem.l > stem.m then do
            t = stem.l; stem.l = stem.m; stem.m = t
         end
         if stem.l > stem.r then do
            t = stem.l; stem.l = stem.r; stem.r = t
         end
         if stem.m > stem.r then do
            t = stem.m; stem.m = stem.r; stem.r = t
         end
         i = l; j = r; p = stem.m
         do until i > j
            do i = i while stem.i < p
            end
            do j = j by -1 while stem.j > p
            end
            if i <= j then do
               t = stem.i; stem.i = stem.j; stem.j = t
               i = i+1; j = j-1
            end
         end
         if j-l < r-i then do
            if i < r then do
               s = s+1; sl.s = i; sr.s = r
            end
            r = j
         end
         else do
            if l < j then do
               s = s+1; sl.s = l; sr.s = j
            end
            l = i
         end
      end
   end
end
return
