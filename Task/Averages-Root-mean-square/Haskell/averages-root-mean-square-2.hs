import Data.List (genericLength)

rootMeanSquare :: [Double] -> Double
rootMeanSquare = sqrt . (((/) . foldr ((+) . (^ 2)) 0) <*> genericLength)

main :: IO ()
main = print $ rootMeanSquare [1 .. 10]
