NB. erdos primes greater than !k and less than or equal to !k+1 (where !k is the factorial of k)
erdospr=: {{ k=. y
  f=. !k+0 1
  p=. (#~ 1= f&I.) p:(+i.)/0 1+p:inv f
  p#~*/|:0=1 p:p-/!i.1+k
}}

NB. erdos primes less than j
erdosprs=: {{ (#~ j&>);erdospr&.>i.>.!inv j=. y }}
