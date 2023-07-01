import Data.List (unfoldr)
import Data.Bool (bool)
import Data.Semigroup (Sum(..), Min(..), Max(..))
import System.IO (writeFile)

fibonacciWord :: a -> a -> [[a]]
fibonacciWord a b = unfoldr (\(a,b) -> Just (a, (b, a <> b))) ([a], [b])

toPath :: [Bool] -> ((Min Int, Max Int, Min Int, Max Int), String)
toPath = foldMap (\p -> (box p, point p)) .
         scanl (<>) mempty .
         scanl (\dir (turn, s) -> bool dir (turn dir) s) (1, 0) .
         zip (cycle [left, right])
  where
    box (Sum x, Sum y) = (Min x, Max x, Min y, Max y)
    point (Sum x, Sum y) = show x ++ "," ++ show y ++ " "
    left (x,y) = (-y, x)
    right (x,y) = (y, -x)

toSVG :: [Bool] -> String
toSVG w =
  let ((Min x1, Max x2, Min y1, Max y2), path) = toPath w
  in unwords
     [ "<svg xmlns='http://www.w3.org/2000/svg'"
     , "width='500' height='500'"
     , "stroke='black' fill='none' strokeWidth='2'"
     , "viewBox='" ++ unwords (show <$> [x1,y1,x2-x1,y2-y1]) ++ "'>"
     , "<polyline points='" ++ path ++ "'/>"
     , "</svg>"]

main = writeFile "test.html" $ toSVG $ fibonacciWord True False !! 21
