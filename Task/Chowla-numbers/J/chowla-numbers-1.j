chowla=: >: -~ >:@#.~/.~&.q:     NB. sum of factors - (n + 1)

intsbelow=: (2 }. i.)"0
countPrimesbelow=: +/@(0 = chowla)@intsbelow
findPerfectsbelow=: (#~ <: = chowla)@intsbelow
