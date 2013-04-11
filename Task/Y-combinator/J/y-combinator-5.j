lambda=:3 :0
  if. 1=#;:y do.
    3 :(y,'=.y',LF,0 :0)`''
  else.
    (,<#;:y) Defer (3 :('''',y,'''=.y',LF,0 :0))`''
  end.
)

Defer=:2 :0
  if. (_1 {:: m) <: #m do.
    v |. y;_1 }. m
  else.
    (y;m) Defer v`''
  end.
)

recursivelY=: lambda 'g recur x'
  (g`:6 recur`:6 recur)`:6 x
)

sivelY=: lambda 'g recur'
  (recursivelY`:6 g)`:6 recur
)

Y=: lambda 'g'
  recur=. sivelY`:6 g
  recur`:6 recur
)

almost_factorial=: lambda 'f n'
  if. 0 >: n do. 1
  else. n * f`:6 n-1 end.
)

almost_fibonacci=: lambda 'f n'
  if. 2 > n do. n
  else. (f`:6 n-1) + f`:6 n-2 end.
)

Ev=: `:6
