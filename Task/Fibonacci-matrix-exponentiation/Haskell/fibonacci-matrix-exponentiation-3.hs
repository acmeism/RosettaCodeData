-- https://yutsumura.com/symmetric-matrices-and-the-product-of-two-matrices/
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
fib 0 = 0
fib n = zeroOne (power (Mat 1 1 1 0)  n)

data Mat a = Mat {zeroZero :: a, zeroOne :: a, oneZero :: a, oneOne :: a} deriving (Eq,Show)

-- for a symmetric matrix
square :: Num a => (Mat a) -> (Mat a)
square (Mat x00 x01 x10 x11) = Mat y00 y10 y10 y11
    where
    y00 = y10 + y11 -- F_{n+1} = F_{n} + F_{n-1}
    y10 = x10*(x00+x11)
    y11 = x11*x11+x10*x10

-- for 2 symmetric matrices which commute
mult :: Num a => (Mat a) -> (Mat a) -> (Mat a)
mult (Mat x00 x01 x10 x11) (Mat y00 y01 y10 y11) = Mat xy00 xy01 xy01 xy11
    where
    xy00 =  xy01 + xy11 -- F_{n+1} = F_{n} + F_{n-1}
    xy01 = x10*y00 + x11*y10
    xy11 = x10*y01 + x11*y11

power :: Num a => (Mat a) -> Integer -> (Mat a)
power _ n | n < 0 = error "Exception: Negative exponent"
power _ 0 = Mat 1 0 0 1
power m 1 = m
power m n = if even n then w else mult w m
   where w = square.power m.quot n $ 2
