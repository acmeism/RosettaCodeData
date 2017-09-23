import Data.List (unfoldr)

hailStones :: Int -> [Int]
hailStones =
  (++ [1]) .
  unfoldr
    (\x ->
        if x < 2
          then Nothing
          else Just
                 ( x
                 , if even x
                     then div x 2
                     else (3 * x) + 1))

mostStones :: Int -> (Int, Int)
mostStones n =
  foldr
    (\x (m, ml) ->
        let l = length (hailStones x)
        in if l > ml
             then (x, l)
             else (m, ml))
    (0, 0)
    [1 .. n]

-- GENERIC  -------------------------------------------------------------------
lastN_ :: Int -> [Int] -> [Int]
lastN_ = (foldr (const (drop 1)) <*>) . drop

-- TEST -----------------------------------------------------------------------
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
