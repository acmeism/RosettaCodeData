NB. sqrt representation for continued fraction
sqrt_cf =: 3 : 0
rep=. '' [ 'm d'=. 0 1 [ a =. a0=. <. %: y
while. a ~: +: a0 do.
  rep=. rep , a=. <. (a0+m) % d=. d %~ y - *: m=. m -~ a*d
end. a0;rep
)

NB. find x,y such that x^2 - n*y^2 = 1 using continued fractions
pell =: 3 : 0
n =. 1 [ 'a0 as' =. x: &.> sqrt_cf y
while. 1 do. cs =. 2 x: (+%)/\ a0, n$as NB. convergents
  if. # sols =. I. 1 = (*: cs) +/ . * 1 , -y do. cs {~ {. sols return. end.
  n =. +: n
end.
)
