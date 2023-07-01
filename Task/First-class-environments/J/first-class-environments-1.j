coclass 'hailstone'

step=:3 :0
  NB. and determine next element in hailstone sequence
  if.1=N do. N return.end.
    NB. count how many times this has run when N was not 1
    STEP=:STEP+1
  if.0=2|N do.
    N=: N%2
  else.
    N=: 1 + 3*N
  end.
)

create=:3 :0
  STEP=: 0
  N=: y
)

current=:3 :0
  N__y
)

run1=:3 :0
  step__y''
  STEP__y
)

run=:3 :0
  old=: ''
  while. -. old -: state=: run1"0 y do.
    smoutput 4j0 ": current"0 y
    old=: state
  end.
)
