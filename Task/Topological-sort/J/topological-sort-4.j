depSort=: monad define
  parsed=. <@;:;._2 y
  names=. {.&>parsed
  depends=. (-.L:0"_1 #,.i.@#) names i.L:1 parsed
  depends=. (~.@,&.> ;@:{L:0 1~)^:_ depends
  assert.-.1 e. (i.@# e.S:0"0 ])depends
  (-.&names ~.;parsed),names /: #@> depends
)
