import Data.Ratio (numerator, denominator, (%))

bernouillis :: Integer -> [Rational]
bernouillis =
  let faulhaber rs n = (:) =<< (-) 1 . sum $ zipWith ((*) . (n %)) [2 ..] rs
  in fmap head . tail . scanl faulhaber [] . enumFromTo 0

bernouilliTable :: Integer -> String
bernouilliTable =
  let row i x =
        [ concat ["B(", show i, ") = ", show n, "/", show (denominator x)]
        | let n = numerator x
        , n /= 0 ]
  in unlines . concat . zipWith row [0 ..] . bernouillis

main :: IO ()
main = putStrLn (bernouilliTable 60)
