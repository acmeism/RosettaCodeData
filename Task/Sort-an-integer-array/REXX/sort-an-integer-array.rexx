-- 31 Mar 2026
include Setting

say 'SORT AN INTEGER ARRAY'
say version
say
-- Generate a demo stem, 100 items, random whole numbers
call MakeSt 'stem.','Z',100
-- Show original, 5 wide per item
call ShowSt 'stem.','random whole numbers',,5
-- Sort with (standard) numeric comparator (quicksort)
call SortSt 'stem.'
-- Show sorted
call ShowSt 'stem.','sorted!',,5
exit

-- MakeSt; ShowSt; SortSt
include Math
