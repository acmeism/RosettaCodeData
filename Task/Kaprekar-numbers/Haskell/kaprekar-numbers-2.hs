import Control.Monad (foldM, join)
import Data.List (group, nub, sort)

primes :: [Int]
primes = 2 : 3 : filter isPrime (scanl (+) 5 $ cycle [2, 4])
  where
    isPrime x = all ((0 /=) . mod x) $ takeWhile ((<= x) . join (*)) primes

unitFactors :: Int -> [Int]
unitFactors n = map product $ group $ f n $ takeWhile ((<= n) . join (*)) primes
  where
    f 1 [] = []
    f n [] = [n]
    f n (p:ps)
      | n `mod` p == 0 = p : f (n `div` p) (p : ps)
      | otherwise = f n ps

-- all factors x of n where x and n/x are coprime
factors :: Int -> [Int]
factors = foldM f 1 . unitFactors
  where
    f x a = [x, x * a]

-- modulo multiplication inverse: returns a where a x + b y == 1
inverse :: Int -> Int -> Int
inverse x y =
  if a < 0
    then a + y
    else a
  where
    (a, b) = extEuclid x y
    extEuclid _ 0 = (1, 0)
    extEuclid x y = (t, s - q * t)
      where
        (s, t) = extEuclid y r
        (q, r) = x `divMod` y

kaprekars :: Int -> Int -> [Int]
kaprekars base top =
  nub . sort . concatMap kaps $
  takeWhile (<= top * top `div` base ^ 2) $ (\x -> base ^ x - 1) <$> [1 ..]
  where
    kaps pb = filter (<= top) $ f <$> factors pb
      where
        f x
          | x == pb = pb
          | otherwise = x * inverse x (pb `div` x)

main :: IO ()
main = mapM_ print $ kaprekars 10 10000000
