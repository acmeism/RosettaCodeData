rare     =:  ( np@:] *. (nbrPs rr) ) b10
  np     =:  -.@:(-: |.)    NB. Not palindromic
  nbrPs  =:  > *. sdPs      NB. n is Bigger than R and the perfect square constraint is satisfied
    sdPs =:  + *.&:ps -     NB. n > rr and both their sum and difference are perfect squares
    ps   =:  0 = 1 | %:     NB. Perfect square (integral sqrt)
  rr     =:  10&#.@:|.      NB. Do note we do reverse the digits twice (once here, once in np)
  b10    =:  10&#.^:_1      NB. Base 10 digits
