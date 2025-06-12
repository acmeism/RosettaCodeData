include Settings

say 'QUICKSORT - 4 Mar 2025'
say version
say
numeric digits 9
arg n v
if n = '' then n = 10
if v = '' then v = 1
show = (n > 0); n = Abs(n)
say 'Timing Version' v 'for' n 'random numbers'
call Generate
if show then call ShowSave
if v = 0 | v = 1 then do
   call Time 'r'; call Save2Stack; say 'Save2Stack' format(time('e'),3,3) 'seconds'
   call Time 'r'; call Quicksort; say 'Quicksort ' format(time('e'),3,3) 'seconds'
   call Time 'r'; call Stack2Stem; say 'Stack2Stem' format(time('e'),3,3) 'seconds'
   if show then call ShowStem
end
if v = 0 | v = 2 then do
   call Save2Stem
   call Time 'r'; call Elegant; say 'Elegant' format(time('e'),3,3) 'seconds'
   if show then call ShowStem
end
if v = 0 | v = 3 then do
   call Save2Stem
   call Time 'r'; call Recursive 1 n; say 'Recursive' format(time('e'),3,3) 'seconds'
   if show then call ShowStem
end
if v = 0 | v = 4 then do
   call Save2Stem
   call Time 'r'; call Optimized; say 'Optimized' format(time('e'),3,3) 'seconds'
   if show then call ShowStem
end
say
exit

Generate:
do x = 1 to n
   save.x = 10000*Random(0,9999)+Random(0,9999)
end
save.0 = n
return

ShowSave:
do x = 1 to 5
   say x save.x
end
do x = n-4 to n
   say x save.x
end
say
return

ShowStem:
do x = 1 to 5
   say x stem.x
end
do x = n-4 to n
   say x stem.x
end
say
return

Save2Stem:
do x = 0 to n
   stem.x = save.x
end
return

Save2Stack:
do x = 1 to n
   queue save.x
end
return

Quicksort: procedure
arr.0 = queued()
do i = 1 to arr.0
    parse pull arr.i
end
less.0 = 0
pivotList.0 = 0
more.0 = 0
if arr.0 <= 1 then do
    if arr.0 = 1 then
        queue arr.1
    return
end
else do
    pivot = arr.1
    do i = 1 to arr.0
        item = arr.i
        select
            when item < pivot then do
                j = less.0 + 1
                less.j = item
                less.0 = j
            end
            when item > pivot then do
                j = more.0 + 1
                more.j = item
                more.0 = j
            end
            otherwise
                j = pivotList.0 + 1
                pivotList.j = item
                pivotList.0 = j
        end
    end
end
do i = 1 to less.0
    queue less.i
end
if queued() > 0 then do
    call quickSort
    less.0 = queued()
    do i = 1 to less.0
        parse pull less.i
    end
end
do i = 1 to more.0
    queue more.i
end
if queued() > 0 then do
    call quickSort
    more.0 = queued()
    do i = 1 to more.0
        parse pull more.i
    end
end
do i = 1 to less.0
    queue less.i
end
do i = 1 to pivotList.0
    queue pivotList.i
end
do i = 1 to more.0
    queue more.i
end
return

Stack2Stem:
do x = 1 to n
   parse pull stem.x
end
return

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

Optimized:
procedure expose stem.
n = stem.0; s = 1; sl.1 = 1; sr.1 = n
do until s = 0
   l = sl.s; r = sr.s; s = s-1
   do until l >= r
      if r-l < 20 then do
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

include Abend
