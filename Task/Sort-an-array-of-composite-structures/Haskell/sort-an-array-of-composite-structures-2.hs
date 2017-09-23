import Data.Ord (comparing)
import Data.List (sortBy)

xs :: [(String, String, Int)]
xs =
  zip3
    (words "Richard John Marvin Alan Maurice James")
    (words "Hamming McCarthy Minskey Perlis Wilkes Wilkinson")
    [1915, 1927, 1926, 1922, 1913, 1919]

main :: IO ()
main = mapM_ print $ sortBy (comparing (\(_, _, y) -> y)) xs
