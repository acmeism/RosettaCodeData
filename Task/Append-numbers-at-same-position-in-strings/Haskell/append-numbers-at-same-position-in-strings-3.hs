apZip :: [a -> b] -> [a] -> [b]
apZip = zipWith id

f :: Integer -> Integer -> Integer -> String
f x y z = [x, y, z] >>= show

main :: IO ()
main = mapM_ putStrLn $

  apZip (apZip (f <$> xs) ys) zs

  where
      xs = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      ys = [10, 11, 12, 13, 14, 15, 16, 17, 18]
      zs = [19, 20, 21, 22, 23, 24, 25, 26, 27]
