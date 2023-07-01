require 'stats'
permfrom=: ,/@(perm@[ {"_ 1 comb)  NB. get permutations of length x from y possible items

alluniq=: # = #@~.           NB. check items are unique
addto12=: 12 = +/            NB. check items add to 12
iseven=: -.@(2&|)            NB. check items are even
policeeven=: {.@iseven       NB. check first item is even
conditions=: policeeven *. addto12 *. alluniq

Validnums=: >: i.7           NB. valid Department numbers

getDeptNums=: [: (#~ conditions"1) Validnums {~ permfrom
