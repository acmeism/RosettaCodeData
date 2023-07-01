import Data.List (genericLength)

shades = ".:!*oe%#&@"
n = genericLength shades
dot a b = sum $ zipWith (*) a b
normalize x = (/ sqrt (x `dot` x)) <$> x

deathStar r k amb = unlines $
  [ [ if x*x + y*y <= r*r
      then let vec = normalize $ normal x y
               b = (light `dot` vec) ** k + amb
               intensity = (1 - b)*(n - 1)
           in shades !! round ((0 `max` intensity) `min` n)
      else ' '
    | y <- map (/2.12) [- 2*r - 0.5 .. 2*r + 0.5]  ]
  | x <- [ - r - 0.5 .. r + 0.5] ]
  where
    light = normalize [-30,-30,-50]
    normal x y
      | (x+r)**2 + (y+r)**2 <= r**2 = [x+r, y+r, sph2 x y]
      | otherwise = [x, y, sph1 x y]
    sph1 x y = sqrt (r*r - x*x - y*y)
    sph2 x y = r - sqrt (r*r - (x+r)**2 - (y+r)**2)
