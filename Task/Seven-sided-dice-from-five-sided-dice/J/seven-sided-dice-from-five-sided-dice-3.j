rollD7x=: monad define
  n=. */y                             NB. product of vector y is total number of D7 rolls required
  rolls=. ''                          NB. initialize empty noun rolls
  while. n > #rolls do.               NB. checks if if enough D7 rolls accumulated
    rolls=. rolls, getD7 >. 0.75 * n  NB. calcs 3/4 of required rolls and accumulates getD7 rolls
  end.
  y $ rolls                           NB. shape the result according to the vector y
)
