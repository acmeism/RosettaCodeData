step_upX=: monad define           NB. iterative
  while. -. +/y do. y=. y , _1 1 {~ step 0 end.
)

step_upR=: monad define           NB. recursive (stack overflow possible!)
   while. -. step'' do. step_upR'' end.
)
