import Data.List (findIndex)

f = succ . flip div 2

-- Or, with redundant verbosity

g n = i
  where
    Just i = succ <$> findIndex (> n) [1, 3 ..]

main = mapM_ print $ [f, g] <*> [1000]
