   truthTable '-.b'
 b -.b
 0   1
 1   0
   truthTable 'a*b'
 a b a*b
 0 0   0
 0 1   0
 1 0   0
 1 1   1
   truthTable 'a+.b'
 a b a+.b
 0 0    0
 0 1    1
 1 0    1
 1 1    1
   truthTable 'a<:b'
 a b a<:b
 0 0    1
 0 1    1
 1 0    0
 1 1    1
   truthTable '(a*bc)+.d'
 a bc d (a*bc)+.d
 0  0 0         0
 0  0 1         1
 0  1 0         0
 0  1 1         1
 1  0 0         0
 1  0 1         1
 1  1 0         1
 1  1 1         1
