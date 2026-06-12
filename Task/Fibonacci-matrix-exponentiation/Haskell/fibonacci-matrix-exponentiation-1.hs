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
formatAns p = start ++ go x
    where
    start = "Fibonacci("++ (formatIntegral "_" p) ++ ") = "
    x = fib p
    tenPow20 = 10^20
    tenPow40 = tenPow20^2
    go u | u <= tenPow20 = show u
    go u | u <= tenPow40 = let (us,vs) = splitAt 20 $ show u in us ++ " ... " ++ vs
    go u = (take 20 $ show u) ++ " ... " ++ (show . rem u $ 10^20)

seeFib :: Integer -> String
seeFib n = start ++ xs ++ " ... " ++ (show . rem x $ 10^20)
    where
    start = "Fibonacci(2^" ++ (show n) ++") = "
    x = fib (2^n)
    xs = take 20 $ show x

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
