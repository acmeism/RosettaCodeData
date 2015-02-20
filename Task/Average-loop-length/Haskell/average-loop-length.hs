import System.Random
import qualified Data.Set as S
import Text.Printf

findRep :: (Random a, Integral a, RandomGen b) => a -> b -> (a, b)
findRep n gen = findRep' (S.singleton 1) 1 gen
    where
      findRep' seen len gen'
          | S.member fx seen = (len, gen'')
          | otherwise        = findRep' (S.insert fx seen) (len + 1) gen''
          where
            (fx, gen'') = randomR (1, n) gen'

statistical :: (Integral a, Random b, Integral b, RandomGen c, Fractional d) =>
               a -> b -> c -> (d, c)
statistical samples size gen =
    let (total, gen') = sar samples gen 0
    in ((fromIntegral total) / (fromIntegral samples), gen')
    where
      sar 0        gen' acc = (acc, gen')
      sar samples' gen' acc =
          let (len, gen'') = findRep size gen'
          in sar (samples' - 1) gen'' (acc + len)

factorial :: (Integral a) => a -> a
factorial n = foldl (*) 1 [1..n]

analytical :: (Integral a, Fractional b) => a -> b
analytical n = sum [fromIntegral num /
                    fromIntegral (factorial (n - i)) /
                    fromIntegral (n ^ i) |
                    i <- [1..n]]
    where num = factorial n

test :: (Integral a, Random b, Integral b, PrintfArg b, RandomGen c) =>
        a -> [b] -> c -> IO c
test _       []     gen = return gen
test samples (x:xs) gen = do
  let (st, gen') = statistical samples x gen
      an         = analytical x
      err        = abs (st - an) / st * 100.0
      str        = printf "%3d  %9.4f  %12.4f  (%6.2f%%)\n"
                   x (st :: Float) (an :: Float) (err :: Float)
  putStr str
  test samples xs gen'

main :: IO ()
main = do
  putStrLn " N    average    analytical    (error)"
  putStrLn "===  =========  ============  ========="
  let samples = 10000 :: Integer
      range   = [1..20] :: [Integer]
  _ <- test samples range $ mkStdGen 0
  return ()
