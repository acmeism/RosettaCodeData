import Data.List (maximumBy)
import Data.Ord (comparing)

main = do putStrLn $ "Collatz sequence for 27: "
            ++ ((show.hailstone) 27)
            ++ "\n"
            ++ "The number "
            ++ (show longestChain)
            ++" has the longest hailstone sequence"
            ++" for any number less then 100000. "
            ++"The sequence has length "
            ++ (show.length.hailstone $ longestChain)

hailstone = takeWhile (/=1) . (iterate collatz)
  where collatz n = if even n then n `div` 2 else 3*n+1

longestChain = fst $ maximumBy (comparing snd) $
               map ((\x -> (x,(length.hailstone) x))) [1..100000]
