lcg=: adverb define
 0 m lcg y                     NB. default seed of 0
:
 'a c mod'=. x: m
 }. (mod | c + a * ])^:(<y+1) x
)

rand_bsd=: (1103515245 12345 , <.2^31) lcg
rand_ms=: (2^16) <.@:%~ (214013 2531011 , <.2^31) lcg
