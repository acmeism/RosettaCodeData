Until=: 2 :'u^:(0-:v)^:_'
assert 44 -: >:Until(>&43) 32  NB. increment until exceeding 43
gcd=: +.
coprime=: 1 = gcd
prepare=:1 2 3"_   NB. start with the vector 1 2 3
condition=: 0 1 -: (coprime _2&{.)   NB. trial coprime most recent 2,  nay and yay
append=: ,      NB. concatenate
novel=: -.@e.   NB. x is not a member of y
term=: >:@:]Until((condition *. novel)~) 4:
ys=: (append term)@]^:(0 >. _3+[) prepare
assert (ys 30) -: 1 2 3 4 9 8 15 14 5 6 25 12 35 16 7 10 21 20 27 22 39 11 13 33 26 45 28 51 32 17
