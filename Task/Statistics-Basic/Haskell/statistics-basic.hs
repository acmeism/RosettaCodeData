import Data.Foldable (foldl') --'
import System.Random (randomRs, newStdGen)
import Control.Monad (zipWithM_)
import System.Environment (getArgs)

intervals :: [(Double, Double)]
intervals = map conv [0 .. 9]
  where
    xs = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
    conv s =
      let [h, l] = take 2 $ drop s xs
      in (h, l)

count :: [Double] -> [Int]
count rands = map (\iv -> foldl'' (loop iv) 0 rands) intervals
  where
    loop :: (Double, Double) -> Int -> Double -> Int
    loop (lo, hi) n x
      | lo <= x && x < hi = n + 1
      | otherwise = n

-- ^ fuses length and filter within (lo,hi)
data Pair a b =
  Pair !a
       !b

-- accumulate sum and length in one fold
sumLen :: [Double] -> Pair Double Double
sumLen = fion2 . foldl'' (\(Pair s l) x -> Pair (s + x) (l + 1)) (Pair 0.0 0)
  where
    fion2 :: Pair Double Int -> Pair Double Double
    fion2 (Pair s l) = Pair s (fromIntegral l)

-- safe division on pairs
divl :: Pair Double Double -> Double
divl (Pair _ 0.0) = 0.0
divl (Pair s l) = s / l

-- sumLen and divl are separate for stddev below
mean :: [Double] -> Double
mean = divl . sumLen

stddev :: [Double] -> Double
stddev xs = sqrt $ foldl'' (\s x -> s + (x - m) ^ 2) 0 xs / l
  where
    p@(Pair s l) = sumLen xs
    m = divl p

main = do
  nr <- read . head <$> getArgs
  -- or in code, e.g.  let nr = 1000
  rands <- take nr . randomRs (0.0, 1.0) <$> newStdGen
  putStrLn $ "The mean is " ++ show (mean rands) ++ " !"
  putStrLn $ "The standard deviation is " ++ show (stddev rands) ++ " !"
  zipWithM_
    (\iv fq -> putStrLn $ ivstr iv ++ ": " ++ fqstr fq)
    intervals
    (count rands)
  where
    fqstr i =
      replicate
        (if i > 50
           then div i (div i 50)
           else i)
        '*'
    ivstr (lo, hi) = show lo ++ " - " ++ show hi

-- To avoid Wiki formatting issue
foldl'' = foldl'
