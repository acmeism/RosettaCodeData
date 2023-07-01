Mraw=: ;: ;._2 noun define -. ':,'
  abe: abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay
  bob: cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay
  col: hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan
  dan: ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi
   ed: jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay
 fred: bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay
  gav: gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay
  hal: abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee
  ian: hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve
  jon: abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope
)

Fraw=: ;: ;._2 noun define -. ':,'
  abi: bob, fred, jon, gav, ian, abe, dan, ed, col, hal
  bea: bob, abe, col, fred, gav, dan, ian, ed, jon, hal
 cath: fred, bob, ed, gav, hal, col, ian, abe, dan, jon
  dee: fred, jon, col, abe, ian, hal, gav, dan, bob, ed
  eve: jon, hal, fred, dan, abe, gav, col, ed, ian, bob
  fay: bob, abe, ed, ian, jon, dan, fred, gav, col, hal
  gay: jon, gav, hal, fred, bob, abe, col, ed, dan, ian
 hope: gav, jon, bob, abe, ian, dan, hal, ed, col, fred
  ivy: ian, col, hal, gav, fred, bob, abe, ed, jon, dan
  jan: ed, hal, gav, abe, bob, jon, col, ian, fred, dan
)

GuyNames=: {."1 Mraw
GalNames=: {."1 Fraw

Mprefs=: GalNames i. }."1 Mraw
Fprefs=: GuyNames i. }."1 Fraw

propose=: dyad define
  engaged=. x
  'guy gal'=. y
  if. gal e. engaged do.
    fiance=. engaged i. gal
    if. guy <&((gal{Fprefs)&i.) fiance do.
      engaged=. gal guy} _ fiance} engaged
    end.
  else.
    engaged=. gal guy} engaged
  end.
  engaged
)

matchMake=: monad define
  engaged=. _"0 GuyNames NB. initially no one is engaged
  fallback=. 0"0 engaged NB. and each guy will first propose to his favorite
  whilst. _ e. engaged do.
    for_guy. I. _ = engaged do.
      next=. guy{fallback
      gal=. (<guy,next){Mprefs
      engaged=. engaged propose guy,gal
      fallback=. (next+1) guy} fallback
    end.
  end.
  GuyNames,:engaged{GalNames
)

checkStable=: monad define
  'guys gals'=. (GuyNames,:GalNames) i."1 y
  satisfied=. ] >: (<0 1) |: ]
  guyshappy=. satisfied (guys{Mprefs) i."1 0/ gals
  galshappy=. satisfied (gals{Fprefs) i."1 0/ guys
  unstable=. 4$.$.-. guyshappy +. |:galshappy
  if. bad=. 0 < #unstable do.
    smoutput 'Engagements preferred by both members to their current ones:'
    smoutput y {~"1 0"2 1 unstable
  end.
  assert-.bad
)
