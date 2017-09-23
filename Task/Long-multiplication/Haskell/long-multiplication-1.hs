import Data.List (transpose, inits)
import Data.Char (digitToInt)

digits :: Integer -> [Integer]
digits = fmap (fromIntegral . digitToInt) . show

lZZ :: [[Integer]]
lZZ = inits $ repeat 0

table :: (Integer -> Integer -> Integer) -> [Integer] -> [Integer] -> [[Integer]]
table f x = fmap $ flip fmap x . f

polymul :: [Integer] -> [Integer] -> [Integer]
polymul xs ys = fmap sum (transpose (zipWith (++) lZZ (table (*) xs ys)))

longmult :: Integer -> Integer -> Integer
longmult x y = foldl1 ((+) . (10 *)) (polymul (digits x) (digits y))

main :: IO ()
main = print $ (2 ^ 64) `longmult` (2 ^ 64)
