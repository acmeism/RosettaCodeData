data X = X
data Y = Y
data Point = Point Int Int deriving Show

createPointAt :: X -> Int -> Y -> Int -> Point
createPointAt X x Y y = Point x y

main = print $ createPointAt X 5 Y 3
