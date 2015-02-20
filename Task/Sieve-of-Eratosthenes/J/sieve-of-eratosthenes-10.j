sieve1=: 3 : 0
  m=. <.%:y
  z=. $0
  b=. y{.1
  while. m>:j=. 1+b i. 0 do.
   b=. b+.y$(-j){.1
   z=. z,j
  end.
  z,1+I.-.b
 )
