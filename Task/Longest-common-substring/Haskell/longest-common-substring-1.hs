import Data.Ord (comparing)
import Data.List (maximumBy, intersect)

subStrings :: [a] -> [[a]]
subStrings s =
  let intChars = length s
  in [ take n $ drop i s
     | i <- [0 .. intChars - 1]
     , n <- [1 .. intChars - i] ]

longestCommon :: Eq a => [a] -> [a] -> [a]
longestCommon a b =
  maximumBy (comparing length) (subStrings a `intersect` subStrings b)

main :: IO ()
main = putStrLn $ longestCommon "testing123testing" "thisisatest"
