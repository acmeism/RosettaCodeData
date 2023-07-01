class Shape a where
    perimeter :: a -> Double
    area      :: a -> Double
{- A type class Shape. Types belonging to Shape must support two
methods, perimeter and area. -}

data Rectangle = Rectangle Double Double
{- A new type with a single constructor. In the case of data types
which have only one constructor, we conventionally give the
constructor the same name as the type, though this isn't mandatory. -}

data Circle = Circle Double

instance Shape Rectangle where
    perimeter (Rectangle width height) = 2 * width + 2 * height
    area      (Rectangle width height) = width * height
{- We made Rectangle an instance of the Shape class by
implementing perimeter, area :: Rectangle -> Int. -}

instance Shape Circle where
    perimeter (Circle radius) = 2 * pi * radius
    area      (Circle radius) = pi * radius^2

apRatio :: Shape a => a -> Double
{- A simple polymorphic function. -}
apRatio shape = area shape / perimeter shape

main = do
    print $ apRatio $ Circle 5
    print $ apRatio $ Rectangle 5 5
{- The correct version of apRatio (and hence the correct
implementations of perimeter and area) is chosen based on the type
of the argument. -}
