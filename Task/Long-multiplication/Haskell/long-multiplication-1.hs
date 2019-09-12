import Data.List (transpose, inits)
import Data.Char (digitToInt)

longmult :: Integer -> Integer -> Integer
longmult x y = foldl1 ((+) . (10 *)) (polymul (digits x) (digits y))

polymul :: [Integer] -> [Integer] -> [Integer]
polymul xs ys =
  sum <$>
  transpose
    (zipWith
       (++)
       (inits $ repeat 0)
       ((\f x -> fmap $ flip fmap x . f) (*) xs ys))

digits :: Integer -> [Integer]
digits = fmap (fromIntegral . digitToInt) . show

main :: IO ()
main = print $ (2 ^ 64) `longmult` (2 ^ 64)
