import Text.Printf
import qualified Data.IntMap.Lazy as IntMap

-- Naïve version that computes series like in the instructions.
-- Programm takes > 15 minutes to complete this way.
inventory_slow :: [Int]
inventory_slow = go []
  where
    go start =
      let cur = countFreqs start
      in cur ++ go (start ++ cur)

-- Counts the fequencies of each number in a list.
-- Returns result as a list where the first entry is frequency of zeros,
-- the second entry the frequencies of ones, and so on.
-- Stops on the first number that has a frequency of zero, that zero is appened to the list.
countFreqs :: [Int] -> [Int]
countFreqs ints = go 0 ints
  where
    go num list =
      let cur = countNum num list
      in case cur of
        0 -> [0]
        _ -> cur : go (succ num) (list ++ [cur])
    countNum num list = length $ filter (== num) list

-- Fast version using hash table.
-- Programm completes in few seconds.
inventory :: [Int]
inventory =  go IntMap.empty 0
  where
    -- im: map from numbers to frequencies
    -- n: current number to check
    go :: IntMap.IntMap Int -> Int -> [Int]
    go im n =
      let c = IntMap.findWithDefault 0 n im
          next_im = IntMap.insertWith (+) c 1 im
          next_n = if c == 0 then 0 else n + 1
       in c : go next_im next_n

main = printFirst100 >> printPosGT1000
  where printFirst100 = goByLine inventory 0
        goByLine next counter = if   counter >= 100 then return ()
                                else (putStr . unwords . map (printf "%4d") . take 10) next
                                     >> putStr "\n" >> goByLine (drop 10 next) (counter + 10)
        printPosGT1000 = goEach1000 inventory 1000 0
        goEach1000 cont limit counter = let (cur, next) = span (<limit) cont
                                            counter' = counter + length cur
                                            val = head next
                                            newLimit = limit + 1000
                                        in (printf "First element ≥ %d : %d index %d\n" limit val counter' :: IO ())
                                           >> if newLimit > 10000 then return () else goEach1000 next newLimit counter'


