import Data.List (maximumBy)
import Data.Ord (comparing)

hailstone :: Int -> [Int]
hailstone = takeWhile (/= 1) . iterate collatz
  where
    collatz n =
      if even n
        then n `div` 2
        else 3 * n + 1

longestChain :: Int
longestChain =
  fst
    (maximumBy (comparing snd) (((,) <*> length . hailstone) <$> [1 .. 100000]))

--TEST -------------------------------------------------------------------------
main =
  mapM_
    putStrLn
    [ "Collatz sequence for 27: "
    , (show . hailstone) 27
    , "The number " ++ show longestChain
    , "has the longest hailstone sequence for any number less then 100000. "
    , "The sequence has length: " ++ (show . length . hailstone $ longestChain)
    ]
