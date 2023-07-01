integrate=: adverb define
  'a b steps'=. 3{.y,128
  size=. (b - a)%steps
  size * +/ u |: 2 ]\ a + size * i.>:steps
)

rectangle=: adverb def 'u -: +/ y'

trapezium=: adverb def '-: +/ u y'

simpson  =: adverb def '6 %~ +/ 1 1 4 * u y, -:+/y'
