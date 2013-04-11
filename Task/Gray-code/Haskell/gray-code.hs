module Main where

main = mapM_ (putStrLn . flip grayconvstr 5) [0..31]

-- Convert number to bit list, MSB first.  Second argument is minimum width.
num2bin :: (Integral t) => t -> t -> [t]
num2bin n w = num2bin' n w [] where
  num2bin' n w acc | n <= 0 && w <= 0 = acc
                   | otherwise = num2bin' m (w-1) (b:acc)
    where (m, b) = divMod n 2

xor2 :: (Integral t) => t -> t -> t
xor2 x y = (x + y) `mod` 2

bin2gray :: (Integral t) => [t] -> [t]
bin2gray [] = []
bin2gray (x:xs) = x : zipWith xor2 xs (x:xs)

gray2bin :: (Integral t) => [t] -> [t]
gray2bin = scanl1 xor2

-- Prettyprinting, since it is in the task description...
grayconvstr :: (Integral t, Show t) => t -> t -> String
grayconvstr n w = (show n) ++ ": " ++ (show b) ++ " => " ++ (show g) ++ " => " ++ (show u)
  where
    b = num2bin n w
    g = bin2gray b
    u = gray2bin g
