import Data.List (unfoldr)


-------------------- HAILSTONE SEQUENCE ------------------

hailStones :: Int -> [Int]
hailStones = (<> [1]) . unfoldr go
  where
    f x
      | even x = div x 2
      | otherwise = 1 + 3 * x
    go x
      | 2 > x = Nothing
      | otherwise = Just (x, f x)

mostStones :: Int -> (Int, Int)
mostStones = foldr go (0, 0) . enumFromTo 1
  where
    go x (m, ml)
      | l > ml = (x, l)
      | otherwise = (m, ml)
      where
        l = length (hailStones x)

------------------------- GENERIC ------------------------
lastN_ :: Int -> [Int] -> [Int]
lastN_ = (foldr (const (drop 1)) <*>) . drop

--------------------------- TEST -------------------------
h27, start27, end27 :: [Int]
[h27, start27, end27] = [id, take 4, lastN_ 4] <*> [hailStones 27]

maxNum, maxLen :: Int
(maxNum, maxLen) = mostStones 100000

main :: IO ()
main =
  mapM_
    putStrLn
    [ "Sequence 27 length:"
    , show $ length h27
    , "Sequence 27 start:"
    , show start27
    , "Sequence 27 end:"
    , show end27
    , ""
    , "N with longest sequence where N <= 100000"
    , show maxNum
    , "length of this sequence:"
    , show maxLen
    ]
