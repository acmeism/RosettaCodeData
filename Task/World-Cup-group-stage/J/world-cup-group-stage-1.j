require'stats'
outcome=: 3 0,1 1,:0 3
pairs=: (i.4) e."1(2 comb 4)
standings=: +/@:>&>,{<"1<"1((i.4) e."1 pairs)#inv"1/ outcome
