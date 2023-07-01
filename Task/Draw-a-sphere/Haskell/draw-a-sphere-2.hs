import Data.List (genericLength)

shades = ".:!*oe%#&@"
n = genericLength shades
dot a b = sum $ zipWith (*) a b
normalize x = (/ sqrt (x `dot` x)) <$> x

sphere r k amb light = unlines $
  [ [ if x*x + y*y <= r*r
      then let vec = normalize [x, y, sqrt (r*r-x*x-y*y)]
               b = (light `dot` vec) ** k + amb
               intensity = (1 - b)*(n - 1)
           in shades !! round ((0 `max` intensity) `min` n)
      else ' '
    | y <- map (/2.12) [- 2*r - 0.5 .. 2*r + 0.5]  ]
  | x <- [ - r - 0.5 .. r + 0.5] ]
