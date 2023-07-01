pritchard=: {{N=. y
  root=. >.@%: N
  spokes=. 1
  primes=. ''
  p=. 0
  while. p<:root do.
    primes=. primes, p=. 2+(}.spokes) i.1 NB. find next prime
    rim=. #spokes NB. "length" of "circumference" of wheel
    spokes=. (N<.p*rim)$spokes NB. roll next larger wheel
    NB. remove multiples of this next prime:
    spokes=. 0 ((#spokes) (>#]) _1+p*1+i.rim)} spokes NB. remove newly recognized prime from wheel
  end.
  N (>:#]) primes,1+}.,I.spokes
}}
