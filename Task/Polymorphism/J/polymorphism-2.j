coclass 'Circle'
coinsert 'Point'
create=: monad define
  'X Y R'=: 3{.y
)
getR=: monad def 'R'
setR=: monad def 'R=:y'
print=: monad define
  smoutput 'Circle ',":X,Y,R
)
