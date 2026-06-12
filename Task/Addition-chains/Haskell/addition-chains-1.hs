import Data.List (union)

-- search strategies
total [] = []
total (x:xs) = brauer (x:xs) `union` total xs

brauer [] = []
brauer (x:xs) = map (+ x) (x:xs)

-- generation of chains with given strategy
chains _ 1 = [[1]]
chains sums n = go [[1]]
  where
    go ch = let next = ch >>= step
                complete = filter ((== n) . head) next
            in if null complete then go next else complete

    step ch = (: ch) <$> filter (\s -> s > head ch && s <= n) (sums ch)

-- the predicate for Brauer chains
isBrauer [_] = True
isBrauer [_,_] = True
isBrauer (x:y:xs) = (x - y) `elem` (y:xs) && isBrauer (y:xs)
