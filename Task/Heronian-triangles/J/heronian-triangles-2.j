perim=: +/"1
s=: -:@:perim
area=: [: %: s * [: */"1 s - ]                    NB. Hero's formula
isNonZeroInt=: 0&~: *. (= <.@:+)
isPrimHero=: isNonZeroInt@area *. 1 = +./&.|:
