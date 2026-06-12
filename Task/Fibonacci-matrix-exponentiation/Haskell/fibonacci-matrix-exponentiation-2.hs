import System.CPUTime (getCPUTime)
import Data.List

main = do
    startTime <- getCPUTime
    mapM_ (putStrLn.formatAns).take 7.iterate (*10) $ 10
    mapM_ (putStrLn.seeFib) [16,32]
    finishTime <- getCPUTime
    putStrLn $ "Took " ++ (took startTime finishTime)

took t = fromChrono.chrono t

fromChrono :: (Integer,Integer,Integer) -> String
fromChrono (m,s,ms) = show m ++ "m" ++ show s ++ "." ++ show ms ++ "s"

chrono :: Integer -> Integer -> (Integer,Integer,Integer)
chrono start end = (m,s,ms)
    where
    tera = 1000000000000
    fdt = fromIntegral (end - start) / tera
    dt = floor fdt
    (m,s) = quotRem dt 60
    ms = round $ fromIntegral (round (fdt - (fromIntegral dt))*1000) / 1000

bagOf :: Int -> [a] -> [[a]]
bagOf _ [] = []
bagOf n xs = let (us,vs) = splitAt n xs in us : bagOf n vs

formatIntegral :: Show a => String -> a -> String
formatIntegral sep = reverse.intercalate sep.bagOf 3.reverse.show

formatAns :: Integer -> String
formatAns p = start ++ (startEnd 20 (sizeFib p) num)
    where
    start = "Fibonacci("++ (formatIntegral "_" p) ++ ") = "
    num = fib p

seeFib :: Integer -> String
seeFib n = start ++ (startEnd 20 (sizeFib p) num)
    where
    start = "Fibonacci(2^" ++ (show n) ++") = "
    p = 2^n
    num = fib p

startEnd :: (Integral a, Show a) => a -> a -> a -> String
startEnd ndigit len num | len <=  ndigit = show num
startEnd ndigit len num | len <= 2*ndigit = let (us,vs) = genericSplitAt ndigit (show num) in us ++ " ... " ++ vs
startEnd ndigit len num =  start ++ " ... " ++ end
    where
    end = show.rem num $ 10 ^ ndigit
    start = show.quot num $ 10 ^ (len - ndigit + 1)

phi :: Double
phi  = (1 + sqrt 5)/2
log10phi = logBase 10 phi
halflog10five =(logBase 10 5)/2

sizeFib :: Integral a => a -> a
sizeFib p = ceiling $ (fromIntegral p)*log10phi - halflog10five

fib :: Integer -> Integer
fib 0 = 0 -- this line is necessary because "something ^ 0" returns "fromInteger 1", which unfortunately
-- in our case is not our multiplicative identity (the identity matrix) but just a 1x1 matrix of 1
fib n = (last . head . unMat) (Mat [[1, 1], [1, 0]] ^ n)

mult :: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs) . zipWith (flip (map . (*))) vss) uss

newtype Mat a = Mat
  { unMat :: [[a]]
  } deriving (Eq,Show)

instance Num a =>  Num (Mat a) where
  negate xm = Mat $ map (map negate) $ unMat xm
  xm + ym = Mat $ zipWith (zipWith (+)) (unMat xm) (unMat ym)
  xm * ym =  Mat $ mult (unMat xm) (unMat ym)
  fromInteger n = Mat [[fromInteger n]]
  abs = undefined
  signum = undefined
