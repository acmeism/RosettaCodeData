sundaram=: {{
 sieve=. -.1{.~k=. <.1.2*(*^.) y
 for_i. 1+i.y do.
  f=. 1+2*i
  j=. (#~ k > ]) (i,f) p. i+i.<.k%f
  if. 0=#j do. y{.1+2*I. sieve return. end.
  sieve=. 0 j} sieve
 end.
}}
