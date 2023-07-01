seriesSum f = foldr ((+) . f) 0

inverseSquare = (1 /) . (^ 2)

main :: IO ()
main = print $ seriesSum inverseSquare [1 .. 1000]
