import Control.Monad.Random
import Control.Applicative
import Text.Printf
import Control.Monad
import Data.Bits

data OneRun = OutRun | InRun deriving (Eq, Show)

randomList :: Int -> Double -> Rand StdGen [Int]
randomList n p = take n . map f <$> getRandomRs (0,1)
  where f n = if (n > p) then 0 else 1

countRuns xs = fromIntegral . sum $
               zipWith (\x y -> x .&. xor y 1) xs (tail xs ++ [0])

calcK :: Int -> Double -> Rand StdGen Double
calcK n p = (/ fromIntegral n) . countRuns <$> randomList n p

printKs :: StdGen -> Double -> IO ()
printKs g p = do
  printf "p= %.1f, K(p)= %.3f\n" p (p * (1 - p))
  forM_ [1..5] $ \n -> do
    let est = evalRand (calcK (10^n) p) g
    printf "n=%7d, estimated K(p)= %5.3f\n" (10^n::Int) est

main = do
  x <- newStdGen
  forM_ [0.1,0.3,0.5,0.7,0.9] $ printKs x
