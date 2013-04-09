data Shape = Rectangle Double Double | Circle Double
{- This Shape is a type rather than a type class. Rectangle and
Circle are its constructors. -}

perimeter :: Shape -> Double
{- An ordinary function, not a method. -}
perimeter (Rectangle width height) = 2 * width + 2 * height
perimeter (Circle radius)          = 2 * pi * radius

area :: Shape -> Double
area (Rectangle width height) = width * height
area (Circle radius)          = pi * radius^2

apRatio :: Shape -> Double
{- Technically, this version of apRatio is monomorphic. -}
apRatio shape = area shape / perimeter shape

main = do
    print $ apRatio $ Circle 5
    print $ apRatio $ Rectangle 5 5
{- The value returned by apRatio is determined by the return values
of area and perimeter, which just happen to be defined differently
for Rectangles and Circles. -}
