data Point = Point {x, y :: Int} deriving Show
defaultPoint = Point {x = 0, y = 0}

createPointAt :: Point -> Point
createPointAt = id
main = print $ createPointAt (defaultPoint { y = 3, x = 5 })
