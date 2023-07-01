import           Control.Monad (guard)
import           Data.List     (intersect, unfoldr, delete, nub, group, sort)
import           Text.Printf   (printf)

type Fraction = (Int, Int)
type Reduction = (Fraction, Fraction, Int)

validIntegers :: [Int] -> [Int]
validIntegers xs = [x | x <- xs, not $ hasZeros x, hasUniqueDigits x]
  where
    hasZeros = elem 0 . digits 10
    hasUniqueDigits n = length ds == length ul
      where
        ds = digits 10 n
        ul = nub ds

possibleFractions :: [Int] -> [Fraction]
possibleFractions = (\ys -> [(n,d) | n <- ys, d <- ys, n < d, gcd n d /= 1]) . validIntegers

digits :: Integral a => a -> a -> [a]
digits b = unfoldr (\n -> guard (n /= 0) >> pure (n `mod` b, n `div` b))

digitsToIntegral :: Integral a => [a] -> a
digitsToIntegral = sum . zipWith (*) (iterate (*10) 1)

findReductions :: Fraction -> [Reduction]
findReductions z@(n1, d1) = [ (z, (n2, d2), x)
                              | x <- digits 10 n1 `intersect` digits 10 d1,
                                let n2 = dropDigit x n1
                                    d2 = dropDigit x d1
                                    decimalWithDrop = realToFrac n2 / realToFrac d2,
                                decimalWithDrop == decimal ]
   where dropDigit d = digitsToIntegral . delete d . digits 10
         decimal = realToFrac n1 / realToFrac d1

findGroupReductions :: [Int] -> [Reduction]
findGroupReductions = (findReductions =<<) . possibleFractions

showReduction :: Reduction -> IO ()
showReduction ((n1,d1),(n2,d2),d) = printf "%d/%d = %d/%d by dropping %d\n" n1 d1 n2 d2 d

showCount :: [Reduction] -> Int -> IO ()
showCount xs n = do
  printf "There are %d %d-digit fractions of which:\n" (length xs) n
  mapM_ (uncurry (printf "%5d have %d's omitted\n")) (countReductions xs) >> printf "\n"
  where
    countReductions = fmap ((,) . length <*> head) . group . sort . fmap (\(_, _, x) -> x)

main :: IO ()
main = do
  mapM_ (\g -> mapM_ showReduction (take 12 g) >> printf "\n") groups
  mapM_ (uncurry showCount) $ zip groups [2..]
  where
    groups = [ findGroupReductions [10^1..99],   findGroupReductions [10^2..999]
             , findGroupReductions [10^3..9999], findGroupReductions [10^4..99999] ]
