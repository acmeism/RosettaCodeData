zero=: _j_

isZero=: 1e20 < |@{.@+.

neg=: +

dbl=: monad define
  'p_x p_y'=. +. p=. y
  if. isZero p do. p return. end.
  L=. 1.5 * p_x*p_x % p_y
  r=. (L*L) - 2*p_x
  r j. (L * p_x-r) - p_y
)

add=: dyad define
  'p_x p_y'=. +. p=. x
  'q_x q_y'=. +. q=. y
  if. x=y do. dbl x return. end.
  if. isZero x do. y return. end.
  if. isZero y do. x return. end.
  L=. %~/ +. q-p
  r=. (L*L) - p_x + q_x
  r j. (L * p_x-r) - p_y
)

mul=: dyad define
  a=. zero
  for_bit.|.#:y do.
    if. bit do.
      a=. a add x
    end.
    x=. dbl x
  end.
  a
)

NB. C is 7
from=: j.~ [:(* * 3 |@%: ]) _7 0 1 p. ]

show=: monad define
  if. isZero y do. 'Zero' else.
    'a b'=. ":each +.y
    '(',a,', ', b,')'
  end.
)

task=: 3 :0
  a=. from 1
  b=. from 2

  echo 'a         = ', show a
  echo 'b         = ', show b
  echo 'c = a + b = ', show c =. a add b
  echo 'd = -c    = ', show d =. neg c
  echo 'c + d     = ', show c add d
  echo 'a + b + d = ', show add/ a, b, d
  echo 'a * 12345 = ', show a mul 12345
)
