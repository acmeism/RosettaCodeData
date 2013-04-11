coclass 'Point'
create=: monad define
  'X Y'=:2{.y
)
getX=: monad def 'X'
getY=: monad def 'Y'
setX=: monad def 'X=:y'
setY=: monad def 'Y=:y'
print=: monad define
  smoutput 'Point ',":X,Y
)
destroy=: codestroy
