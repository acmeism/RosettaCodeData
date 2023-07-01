task :: State -> State
task = iterate step
   >>> dropWhile ((< 50) . distance . antPosition)
   >>> getCells . head
  where distance (x,y) = max (abs x) (abs y)
