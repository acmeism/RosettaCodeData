-- add this to the top
import Control.Concurrent.ParallelIO.Global (parallel, stopGlobalPool)
import Data.List (sort, group)

-- replace "logic _      _      ((won -> True)    : xs) = return ()" with
  logic _      _      (p@(won -> True)    : xs) = return $ name p

-- replace strat1 [p1, p2, p3, p4] in main with
  let lists = replicate 100000 [p1, p2, p3, p4]
  results <- parallel $ map strat1 lists
  stopGlobalPool
  print $ map length $ group $ sort results

-- replace type Strategy = [PInfo] -> IO () with
  type Strategy = [PInfo] -> IO String

-- comment every printf in "roll" and "hold"

-- compile with
-- ghc FILENAME.hs -O2 -threaded -with-rtsopts="-N4" -o dice
