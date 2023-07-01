coclass 'uncubicalSquares'
  N=: 0
  next=: 3 :0"0
    while. (-: <.) 3 %: *: n=. N do. N=: N+1 end. N=: N+1
    *: n
  )
