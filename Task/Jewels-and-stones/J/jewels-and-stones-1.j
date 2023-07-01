   NB. jewels sums a raveled equality table
   NB. use: x jewels y  x are the stones, y are the jewels.
   intersect =: -.^:2
   jewels =: ([: +/ [: , =/~) ~.@:intersect&Alpha_j_

   'aAAbbbb ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz' jewels&>&;: 'aA ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz'
3 52

   'none' jewels ''
0
   'ZZ' jewels 'z'
0
