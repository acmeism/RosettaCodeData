two_sum=:dyad define
  sums=. +/~ y
  matches=.  x = sums
  sum_inds=. I. , matches
  pair_inds=. ($matches) #: sum_inds
  ; {. a: ,~ <"1 pair_inds
)
