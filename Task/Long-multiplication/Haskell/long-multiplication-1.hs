import Data.List (transpose)
import Data.Char (digitToInt)
import Data.List (inits)

digits :: Integer -> [Integer]
digits = map (fromIntegral . digitToInt) . show

lZZ = inits $ repeat 0

table f = map . flip (map . f)

polymul = ((map sum . transpose . zipWith (++) lZZ) .) . table (*)

longmult = (foldl1 ((+) . (10 *)) .) . (. digits) . polymul . digits

main = print $ (2 ^ 64) `longmult` (2 ^ 64)
