   1 1 0 1#3 4 _ 5           NB. use bitmask to select numbers
3 4 5
   I.1 1 0 1                 NB. get indices for bitmask
0 1 3
   0 1 3 { 3 4 _ 5           NB. use indices to select numbers
3 4 5
   1 1 0 1 #inv 3 4 5        NB. use bitmask to restore original positions
3 4 0 5
   1 1 0 1 #!._ inv 3 4 5    NB. specify different fill element
3 4 _ 5
   3 4 5 (0 1 3}) _ _ _ _    NB. use indices to restore original positions
3 4 _ 5
