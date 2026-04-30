-- 31 Mar 2026
include Setting

say 'SORT DISJOINT SUBLIST'
say version
say
call Struct2stem 'val1.','7 6 5 4 3 2 1 0'
call Struct2stem 'indx.','7 2 8'
call Collect
call ShowSt 'val1.','value1 before',,3
call ShowSt 'indx.','index before',,3
call ShowSt 'val2.','value2 before',,3
-- 1 Order by index, sync value
call SortSt 'indx.','val2.'
call ShowSt 'indx.','index after sort1',,3
call ShowSt 'val2.','value2 after sort1',,3
-- 2 Order by value, leave index in place
call SortSt 'val2.'
call ShowSt 'indx.','index after sort2',,3
call ShowSt 'val2.','value2 after sort2',,3
-- 3 Put ordered values back in list
call Update
call ShowSt 'val1.','value1 result',,3
exit

Collect:
procedure expose val1. indx. val2.
-- Collect values requested indices
do i=1 to indx.0
   j=indx.i; val2.i=val1.j
end
val2.0=indx.0
return

Update:
procedure expose val1. indx. val2.
-- Restore sorted values
do i=1 to indx.0
   j=indx.i; val1.j=val2.i
end
return

-- ShowSt; SortSt; Struct2stem
include Math
