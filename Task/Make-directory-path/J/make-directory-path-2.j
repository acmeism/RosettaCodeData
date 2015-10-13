pathcreate=: monad define
  todir=. termsep_j_ jpathsep y
  todirs=. }. ,each /\ <;.2 todir  NB. base dirs
  msk=. -.direxist todirs          NB. 1 for each non-existing dir
  msk=. 0 (i. msk i: 0)}msk
  dircreate msk#todirs             NB. create non-existing base dirs
)

dircreate=: monad define
  y=. boxxopen y
  msk=. -.direxist y
  if. ''-:$msk do. msk=. (#y)#msk end.
  res=. 1!:5 msk#y
  msk #inv ,res
)

direxist=: 2 = ftype&>@:boxopen
