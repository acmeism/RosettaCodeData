dependencySort=: monad define
  parsed=. <@;:;._2 y
  names=. {.&>parsed
  depends=. (> =@i.@#) names e.S:1 parsed
  depends=. (+. +./ .*.~)^:_ depends
  assert.-.1 e. (<0 1)|:depends
  (-.&names ~.;parsed),names /: +/"1 depends
)
