congeal=: |.@|:@((*@[*>.)/\.)^:4^:_
idclust=: $ $ [: (~. i.])&.(0&,)@,@congeal  ] * 1 + i.@$

K=: (%&#~ }.@~.)&,

experiment=: K@ idclust@: > 0 ?@$~ ,~
trials=: 0.5&experiment"0@#

mean=:+/ % #

thru=: <./ + i.@(+*)@-~
