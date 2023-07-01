-- |This is a documentation comment for the following function
square1 :: Int -> Int
square1 x = x * x

-- |It can even
-- span multiple lines
square2 :: Int -> Int
square2 x = x * x

square3 :: Int -> Int
-- ^You can put the comment underneath if you like, like this
square3 x = x * x

{-|
  Haskell block comments
  are also supported
-}
square4 :: Int -> Int
square4 x = x * x

-- |This is a documentation comment for the following datatype
data Tree a = Leaf a | Node [Tree a]

-- |This is a documentation comment for the following type class
class Foo a where
    bar :: a
