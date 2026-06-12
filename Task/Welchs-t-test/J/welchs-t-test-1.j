integrate=: adverb define
  'a b steps'=. 3{.y,128
  size=. (b - a)%steps
  size * +/ u |: 2 ]\ a + size * i.>:steps
)
simpson  =: adverb def '6 %~ +/ 1 1 4 * u y, -:+/y'

lngamma=: ^.@!@<:`(^.@!@(1 | ]) + +/@:^.@(1 + 1&| + i.@<.)@<:)@.(1&<:)"0
mean=: +/ % #
nu=: # - 1:
sampvar=: +/@((- mean) ^ 2:) % nu
ssem=: sampvar % #
welch_T=: -&mean % 2 %: +&ssem
nu=: nu f. : ((+&ssem ^ 2:) % +&((ssem^2:)%nu))
B=: ^@(+&lngamma - lngamma@+)

p2_tail=:dyad define
  t=. x welch_T y  NB. need numbers for numerical integration
  v=. x nu y
  F=. ^&(_1+v%2) % 2 %: 1&-
  lo=. 0
  hi=. v%(t^2)+v
  (F f. simpson integrate lo,hi) % 0.5 B v%2
)
