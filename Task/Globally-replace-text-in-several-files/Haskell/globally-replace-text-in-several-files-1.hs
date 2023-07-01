import Data.List (tails, elemIndices, isPrefixOf)

replace :: String -> String -> String -> String
replace [] _ xs = xs
replace _ [] xs = xs
replace _ _ []  = []
replace a b xs  = replAll
    where
        -- make substrings, dropping one element each time
        xtails = tails xs
        -- what substrings begin with the string to replace?
        -- get their indices
        matches = elemIndices True $ map (isPrefixOf a) xtails
        -- replace one occurrence
        repl ys n = take n ys ++ b ++ drop (n + length b) ys
        -- replace all occurrences consecutively
        replAll = foldl repl xs matches

replaceInFiles a1 a2 files = do
    f <- mapM readFile files
    return $ map (replace a1 a2) f
