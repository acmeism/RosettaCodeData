two_sum=:dyad define
  sums=. +/~ y
  matches=.  x = sums
  sum_inds=. I. , matches
  pair_inds=. ($matches) #: sum_inds
  if. #pair_inds do.
    {.pair_inds
  else.
    i.0
  end.
)
