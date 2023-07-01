grid=: 4 : 'x (<<.-:2$y)} (2$y)$0'         NB. y by y grid with x grains in middle
ab=: - [: +/@(-"2 ((,-)=/~i.2)|.!.0]) 3&<  NB. abelian sand pile for grid graph
require 'viewmat'                          NB. viewmat utility
viewmat ab ^: _ (1024 grid 25)             NB. visual
