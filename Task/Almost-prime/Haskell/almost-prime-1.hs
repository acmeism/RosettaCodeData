isPrime :: Integral a => a -> Bool
isPrime n = not $ any ((0 ==) . (mod n)) [2..(truncate $ sqrt $ fromIntegral n)]

primes :: [Integer]
primes = filter isPrime [2..]

isKPrime :: (Num a, Eq a) => a -> Integer -> Bool
isKPrime 1 n = isPrime n
isKPrime k n = any (isKPrime (k - 1)) sprimes
  where
    sprimes = map fst $ filter ((0 ==) . snd) $ map (divMod n) $ takeWhile (< n) primes

kPrimes :: (Num a, Eq a) => a -> [Integer]
kPrimes k = filter (isKPrime k) [2..]

main :: IO ()
main = flip mapM_ [1..5] $ \k ->
  putStrLn $ "k = " ++ show k ++ ": " ++ (unwords $ map show (take 10 $ kPrimes k))
