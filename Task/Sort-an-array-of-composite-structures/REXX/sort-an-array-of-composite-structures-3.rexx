default [label]=Quicksort21 [table]=table. [key1]=key1. [key2]=key2. [data1]=data1. [lt]=< [eq]== [gt]=>
-- Sorting procedure - Build 7 Sep 2024
-- (C) Paul van den Eertwegh 2024

[label]:
-- Sort a stem on 2 key columns, syncing 1 data column
procedure expose [table]
-- Sort
n = [table]0; s = 1; sl.1 = 1; sr.1 = n
do until s = 0
   l = sl.s; r = sr.s; s = s-1
   do until l >= r
-- Up to 19 rows selection sort is faster
      if r-l < 20 then do
         do i = l+1 to r
            a = [table][key1]i
            b = [table][key2]i
            c = [table][data1]i
            do j = i-1 by -1 to l
               if [table][key1]j [lt] a then
                  leave
               if [table][key1]j [eq] a then
                  if [table][key2]j [lt]= b then
                     leave
               k = j+1
               [table][key1]k = [table][key1]j
               [table][key2]k = [table][key2]j
               [table][data1]k = [table][data1]j
            end
            k = j+1
            [table][key1]k = a
            [table][key2]k = b
            [table][data1]k = c
         end
         if s = 0 then
            leave
         l = sl.s; r = sr.s; s = s-1
      end
      else do
-- Find optimized pivot
         m = (l+r)%2
         if [table][key1]l [gt] [table][key1]m then do
            t = [table][key1]l; [table][key1]l = [table][key1]m; [table][key1]m = t
            t = [table][key2]l; [table][key2]l = [table][key2]m; [table][key2]m = t
            t = [table][data1]l; [table][data1]l = [table][data1]m; [table][data1]m = t
         end
         else do
            if [table][key1]l [eq] [table][key1]m then do
               if [table][key2]l [gt] [table][key2]m then do
                  t = [table][key2]l; [table][key2]l = [table][key2]m; [table][key2]m = t
                  t = [table][data1]l; [table][data1]l = [table][data1]m; [table][data1]m = t
               end
            end
         end
         if [table][key1]l [gt] [table][key1]r then do
            t = [table][key1]l; [table][key1]l = [table][key1]r; [table][key1]r = t
            t = [table][key2]l; [table][key2]l = [table][key2]r; [table][key2]r = t
            t = [table][data1]l; [table][data1]l = [table][data1]r; [table][data1]r = t
         end
         else do
            if [table][key1]l [eq] [table][key1]r then do
               if [table][key2]l [gt] [table][key2]r then do
                  t = [table][key2]l; [table][key2]l = [table][key2]r; [table][key2]r = t
                  t = [table][data1]l; [table][data1]l = [table][data1]r; [table][data1]r = t
               end
            end
         end
         if [table][key1]m [gt] [table][key1]r then do
            t = [table][key1]m; [table][key1]m = [table][key1]r; [table][key1]r = t
            t = [table][key2]m; [table][key2]m = [table][key2]r; [table][key2]r = t
            t = [table][data1]m; [table][data1]m = [table][data1]r; [table][data1]r = t
         end
         else do
            if [table][key1]m [eq] [table][key1]r then do
               if [table][key2]m [gt] [table][key2]r then do
                  t = [table][key2]m; [table][key2]m = [table][key2]r; [table][key2]r = t
                  t = [table][data1]m; [table][data1]m = [table][data1]r; [table][data1]r = t
               end
            end
         end
-- Rearrange rows in partition
         i = l; j = r
         a = [table][key1]m
         b = [table][key2]m
         do until i > j
            do i = i
               if [table][key1]i [gt] a then
                  leave
               if [table][key1]i [eq] a then
                  if [table][key2]i [gt]= b then
                     leave
            end
            do j = j by -1
               if [table][key1]j [lt] a then
                  leave
               if [table][key1]j [eq] a then
                  if [table][key2]j [lt]= b then
                     leave
            end
            if i <= j then do
               t = [table][key1]i; [table][key1]i = [table][key1]j; [table][key1]j = t
               t = [table][key2]i; [table][key2]i = [table][key2]j; [table][key2]j = t
               t = [table][data1]i; [table][data1]i = [table][data1]j; [table][data1]j = t
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
