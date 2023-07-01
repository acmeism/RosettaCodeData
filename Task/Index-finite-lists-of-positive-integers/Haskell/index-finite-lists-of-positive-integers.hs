import Data.List

toBase :: Int -> Integer -> [Int]
toBase b = unfoldr f
  where
    f 0 = Nothing
    f n = let (q, r) = n `divMod` fromIntegral b in Just (fromIntegral r, q)

fromBase :: Int -> [Int] -> Integer
fromBase n lst = foldr (\x r -> fromIntegral n*r + fromIntegral x) 0 lst

------------------------------------------------------------

listToInt :: Int -> [Int] -> Integer
listToInt b lst = fromBase (b+1) $ concat seq
  where
    seq = [ let (q, r) = divMod n b
            in replicate q 0 ++ [r+1]
          | n <- lst ]

intToList :: Int -> Integer -> [Int]
intToList b lst = go 0 $ toBase (b+1) lst
  where
    go 0 [] = []
    go i (0:xs) = go (i+1) xs
    go i (x:xs) = (i*b + x - 1) : go 0 xs
