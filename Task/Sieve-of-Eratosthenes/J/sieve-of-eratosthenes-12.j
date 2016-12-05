sieve2=: 3 : 0
 m=. <.%:y
 z=. y (>:#]) 2 3 5 7
 b=. 1,}.y$+./(*/z)$&>(-z){.&.>1
 while. m>:j=. 1+b i. 0 do.
  b=. b+.y$(-j){.1
  z=. z,j
 end.
 z,1+I.-.b
)
