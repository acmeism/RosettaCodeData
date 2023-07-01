pr =: {{N=.y
  root=. <.%:N  NB. performance optimzation
  circumference=. 1
  spokes=. ,1
  primes=. ''
  while. N > L=. circumference do.
    primes=. primes, p =. 1{ spokes,L+1  NB. next prime from sieve
    circumference=. N <. p * L           NB. next larger wheel:
    spokes=. circumference (>:#]), spokes +/~ L * i.circumference >.@% L
    NB. remove multiples of this next prime:
    spokes=. spokes -. p * spokes ( [{.~ >:@:(I.-(-.@e.)~))circumference<.@%p
  end.
  NB. set up for optimized version of above code
  comb=. root (>:#]) }. spokes NB. candidate next primes to consider
  discardp=. discard=. '' NB. what we'll be eliminating
  for_p. comb do.
    if. p e. comb =. comb (-. }.) discardp do.
      NB. remove multiples of this next prime:
      discardp=. p * spokes ( [{.~ >:@:(I.-(-.@e.)~))circumference<.@%p
      discard =. discard, discardp
    end.
  end.
  primes,comb,}.spokes-.discard
}}
