mp=: +/ .*           NB. matrix product
norm=: +/&.:*:       NB. vector norm
normalize=: (% norm)^:(0 < norm)

dxy=. normalize@({: - {.)
pv=. -"1 {.
NB.*perpDist v Calculate perpendicular distance of points from a line
perpDist=: norm"1@(pv ([ -"1 mp"1~ */ ]) dxy) f.

rdp=: verb define
  1 rdp y
  :
  points=. ,:^:(2 > #@$) y
  epsilon=. x
  if. 2 > # points do. points return. end.

  NB. point with the maximum distance from line between start and end
  'imax dmax'=. ((i. , ]) >./) perpDist points
  if. dmax > epsilon do.
    epsilon ((}:@rdp (1+imax)&{.) , (rdp imax&}.)) points
  else.
    ({. ,: {:) points
  end.
)
