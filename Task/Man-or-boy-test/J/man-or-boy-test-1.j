A=:4 :0
  L=.cocreate''  NB. L is context where names are defined.
  k__L=:x
  '`x1__L x2__L x3__L x4__L x5__L'=:y
  if.k__L<:0 do.a__L=:(x4__L + x5__L)f.'' else. L B '' end.
  (coerase L)]]]a__L
)

B=:4 :0
  L=.x
  k__L=:k__L-1
  a__L=:k__L A L&B`(x1__L f.)`(x2__L f.)`(x3__L f.)`(x4__L f.)
)
