pascal :: [[Integer]]
pascal =
  (1 : [ 0 | _ <- head pascal])
  : [zipWith (+) (0:row) row | row <- pascal]
