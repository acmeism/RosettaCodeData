NB. knight moves for each square of a (y,y) board
kmoves=: monad define
 t=. (>,{;~i.y) +"1/ _2]\2 1 2 _1 1 2 1 _2 _1 2 _1 _2 _2 1 _2 _1
 (*./"1 t e. i.y) <@#"1 y#.t
)

ktourw=: monad define
 M=. >kmoves y
 p=. k=. 0
 b=. 1 $~ *:y
 for. i.<:*:y do.
  b=. 0 k}b
  p=. p,k=. ((i.<./) +/"1 b{~j{M){j=. ({&b # ]) k{M
 end.
 assert. ~:p
 (,~y)$/:p
)
