import System.Random
import Data.List
import Control.Monad
import Control.Arrow

primesTo100 = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97]

powerMod :: (Integral a, Integral b) => a -> a -> b -> a
powerMod m _ 0 =  1
powerMod m x n | n > 0 = join (flip f (n - 1)) x `rem` m where
  f _ 0 y = y
  f a d y = g a d where
    g b i | even i    = g (b*b `rem` m) (i `quot` 2)
          | otherwise = f b (i-1) (b*y `rem` m)

witns :: (Num a, Ord a, Random a) => Int -> a -> IO [a]
witns x y = do
     g <- newStdGen
     let r = [9080191, 4759123141, 2152302898747, 3474749600383, 341550071728321]
         fs = [[31,73],[2,7,61],[2,3,5,7,11],[2,3,5,7,11,13],[2,3,5,7,11,13,17]]
     if  y >= 341550071728321
      then return $ take x $ randomRs (2,y-1) g
       else return $ snd.head.dropWhile ((<= y).fst) $ zip r fs

isMillerRabinPrime :: Integer -> IO Bool
isMillerRabinPrime n | n `elem` primesTo100 = return True
                     | otherwise = do
    let pn = pred n
        e = uncurry (++) . second(take 1) . span even . iterate (`div` 2) $ pn
        try = return . all (\a -> let c = map (powerMod n a) e in
                                  pn `elem` c || last c == 1)
    witns 100 n >>= try
