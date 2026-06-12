isPrime x
  |x == 1 = False
  |x == 2 = True
  |even x = False
  |otherwise = not $ any (\i -> x `mod` i == 0) [2..(floor (sqrt (fromIntegral x)))]


residueList n = takeWhile (>0) [n - 2^i | i <- [0..]]

isNotDePolignac n = any (isPrime) (residueList n)

dePolignacNums = filter (not.isNotDePolignac) [1,3..]

main = do
  putStrLn $ "The first 50 numbers are: " ++ show (take 50 (dePolignacNums))
  putStrLn $ "The 1000th number is: " ++ show (dePolignacNums !! 1001)
  putStrLn $ "The 10000th number is: " ++ show (dePolignacNums !! 10001)
