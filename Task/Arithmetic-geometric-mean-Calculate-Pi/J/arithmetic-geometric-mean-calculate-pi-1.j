DP=: 100

round=: DP&$: : (4 : 0)
 b %~ <.1r2+y*b=. 10x^x
)

sqrt=: DP&$: : (4 : 0) " 0
 assert. 0<:y
 %/ <.@%: (2 x: (2*x) round y)*10x^2*x+0>.>.10^.y
)

pi =: 3 : 0
 A =. N =. 1x
 'G Z HALF' =. (% sqrt 2) , 1r4 1r2
 for_I. i.18 do.
  X =. ((A + G) * HALF) , sqrt A * G
  VAR =. ({.X) - A
  Z =. Z - VAR * VAR * N
  N =. +: N
  'A G' =. X
  PI =: A * A % Z
  echo (0j100":PI) , 4 ": I
 end.
 PI
)
