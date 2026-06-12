leg=: dyad define
  x (y&|)@^ (y-1)%2
)

mul2=: conjunction define
  m| (*&{. + n**&{:), (+/ .* |.)
)

pow2=: conjunction define
:
  if. 0=y do. 1 0
  elseif. 1=y do. x
  elseif. 2=y do. x (m mul2 n) x
  elseif. 0=2|y do. (m mul2 n)~ x (m pow2 n) y%2
  elseif. do. x (m mul2 n) x (m pow2 n) y-1
  end.
)

cipolla=: dyad define
  assert. 1=1 p: y [ 'y must be prime'
  assert. 1= x leg y [ 'x must be square mod y'
  a=.1
  whilst. (0 ~:{: r) do. a=. a+1
    while. 1>: leg&y@(x -~ *:) a do. a=.a+1 end.
    w2=. y|(*:a) - x
    r=. (a,1) (y pow2 w2) (y+1)%2
  end.
  if. x =&(y&|) *:{.r do.
    y|(,-){.r
  else.
    smoutput 'got ',":~.y|(,-){.r
    assert. 'not a valid square root'
  end.
)
