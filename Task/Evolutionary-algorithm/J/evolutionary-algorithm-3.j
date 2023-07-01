CHARSET=: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ '
NPROG=:   100                             NB. "C" from specification

fitness=: +/@:~:"1
select=: ] {~ (i. <./)@:fitness           NB. select fittest member of population
populate=: (?@$&# { ])&CHARSET            NB. get random list from charset of same length as y
log=: [: smoutput [: ;:inv (('#';'fitness: ';'; ') ,&.> ":&.>)

mutate=: dyad define
  idxmut=. I. x >: (*/$y) ?@$ 0
  (populate idxmut) idxmut"_} y
)

evolve=: monad define
  target=. y
  parent=. populate y
  iter=. 0
  mrate=. %#y
  while. 0 < val=. target fitness parent do.
    if. 0 = 50|iter do. log iter;val;parent end.
    iter=. iter + 1
    progeny=. mrate mutate NPROG # ,: parent  NB. create progeny by mutating parent copies
    parent=. target select parent,progeny     NB. select fittest parent for next generation
  end.
  log iter;val;parent
  parent
)
