-- Module Quicksort.inc - Build 30 Jan 2025
-- Generic stem sort

default [label]=Quicksort [lt]=< [eq]== [gt]=>

[label]:
-- Sort a stem on 1 or more key columns, syncing 0 or more data columns
procedure expose (table)
arg table,keys,data
-- Collect keys
kn = Words(keys)
do x = 1 to kn
   key.x = Word(keys,x)
end
-- Collect data
dn = Words(data)
do x = 1 to dn
   data.x = Word(data,x)
end
-- Sort
n = Value(table||0); s = 1; sl.1 = 1; sr.1 = n
do until s = 0
   l = sl.s; r = sr.s; s = s-1
   do until l >= r
-- Up to 19 rows insertion sort is faster
      if r-l < 20 then do
         do i = l+1 to r
            do x = 1 to kn
               k.x = Value(table||key.x||i)
            end
            do x = 1 to dn
               d.x = Value(table||data.x||i)
            end
            do j=i-1 to l by -1
               do x = 1 to kn
                  a = Value(table||key.x||j)
                  if a [gt] k.x then
                     leave x
                  if a [eq] k.x then
                     if x < kn then
                        iterate x
                  leave j
               end
               k = j+1
               do x = 1 to kn
                  t = Value(table||key.x||j)
                  call value table||key.x||k,t
               end
               do x = 1 to dn
                  t = Value(table||data.x||j)
                  call value table||data.x||k,t
               end
            end
            k = j+1
            do x = 1 to kn
               call value table||key.x||k,k.x
            end
            do x = 1 to dn
               call value table||data.x||k,d.x
            end
         end
         if s = 0 then
            leave
         l = sl.s; r = sr.s; s = s-1
      end
      else do
-- Find optimized pivot
         m = (l+r)%2
         do x = 1 to kn
            a = Value(table||key.x||l); b = Value(table||key.x||m)
            if a [gt] b then do
               do y = 1 to kn
                  t = Value(table||key.y||l); u = Value(table||key.y||m)
                  call value table||key.y||l,u; call value table||key.y||m,t
               end
               do y = 1 to dn
                  t = Value(table||data.y||l); u = Value(table||data.y||m)
                  call value table||data.y||l,u; call value table||data.y||m,t
               end
               leave
            end
            if a [lt] b then
               leave
         end
         do x = 1 to kn
            a = Value(table||key.x||l); b = Value(table||key.x||r)
            if a [gt] b then do
               do y = 1 to kn
                  t = Value(table||key.y||l); u = Value(table||key.y||r)
                  call value table||key.y||l,u; call value table||key.y||r,t
               end
               do y = 1 to dn
                  t = Value(table||data.y||l); u = Value(table||data.y||r)
                  call value table||data.y||l,u; call value table||data.y||r,t
               end
               leave
            end
            if a [lt] b then
               leave
         end
         do x = 1 to kn
            a = Value(table||key.x||m); b = Value(table||key.x||r)
            if a [gt] b then do
               do y = 1 to kn
                  t = Value(table||key.y||m); u = Value(table||key.y||r)
                  call value table||key.y||m,u; call value table||key.y||r,t
               end
               do y = 1 to dn
                  t = Value(table||data.y||m); u = Value(table||data.y||r)
                  call value table||data.y||m,u; call value table||data.y||r,t
               end
               leave
            end
            if a [lt] b then
               leave
         end
-- Rearrange rows in partition
         i = l; j = r
         do x = 1 to kn
            p.x = Value(table||key.x||m)
         end
         do until i > j
            do i = i
               do x = 1 to kn
                  a = Value(table||key.x||i)
                  if a [lt] p.x then
                     leave x
                  if a [eq] p.x then
                     if x < kn then
                        iterate x
                  leave i
               end
            end
            do j = j by -1
               do x = 1 to kn
                  a = Value(table||key.x||j)
                  if a [gt] p.x then
                     leave x
                  if a [eq] p.x then
                     if x < kn then
                        iterate x
                  leave j
               end
            end
            if i <= j then do
               do x = 1 to kn
                  t = Value(table||key.x||i); u = Value(table||key.x||j)
                  call value table||key.x||i,u; call value table||key.x||j,t
               end
               do x = 1 to dn
                  t = Value(table||data.x||i); u = Value(table||data.x||j)
                  call value table||data.x||i,u; call value table||data.x||j,t
               end
               i = i+1; j = j-1
            end
         end
-- Next partition
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
