expandRange :: String -> [Int]
expandRange = concatMap f . split ','
  where f str@(c : cs) | '-' `elem` cs = [read (c : a) .. read b]
                       | otherwise     = [read str]
            where (a, _ : b) = break (== '-') cs

split :: Eq a => a -> [a] -> [[a]]
split delim [] = []
split delim l = a : split delim (dropWhile (== delim) b)
  where (a, b) = break (== delim) l
