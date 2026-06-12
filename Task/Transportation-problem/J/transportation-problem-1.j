NB. C's y[m] v= x  implemented as  x m ndxasgn v y
ndxasgn=: conjunction define
:
  ((m{y)v x) m} y
)

trans=: adverb define
:
  need=. x
  supl=. y
  cost=. m
  dims=. supl ,&# need
  r=. dims$0
  while. 1 e., xfr=. supl *&*/ need do.
    'iS iN'=. ndxs=. dims#:(i. <./), cost % xfr
    n=. (iS { supl) <. iN { need
    need=. n iN ndxasgn - need
    supl=. n iS ndxasgn - supl
    r=. n (<ndxs)} r
  end.
)
