NB. Primes Not Greater Than (the input)
NB. The 1 _1 p: ... logic here allows the input value to
NB. be included in the list in the case it itself is prime
pngt =: p:@:i.@:([: +/ 1 _1 p:"0 ])

NB.  Add 6 and see which sums appear in input list
sexy =:  ] #~ + e. ]

NB.  Iterate "sexy" logic up to orgy size
orgy =:  sexy&.>^:( ({.@:[) ` (<@:{:@:[) ` (<@:]) )

sp =: dyad define
  'pd os' =. x  NB. x is  prime distance (6), orgy size (5)
  p =.  pngt y
  o =.  x orgy p
  g =.  o +/&.> <\ +/\ _1 |.!.0 os # pd NB. Groups

  's g' =.  split g  NB. Split singles from groups
  l =. (({.~ -) 5 <. #)&.> g NB. Last (max) 5 groups

  NB. I'm sure there's something clever with p-.s or similar,
  NB. but (a) I don't want to think through it, and (b)
  NB. it causes the kind of edge-case issues the spec warns
  NB. about with 1000033
  us =. p (] #~ 1 +:/@:p: +/)~ (+,-) pd NB. Unsexy numbers
  ( (# ; _10&{.) us ) , (#&.> g) ,. l
)
