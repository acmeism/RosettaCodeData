{- Take a certain substring, specified by
two integers, from the given string -}
strPull :: Int -> Int -> String -> String
strPull x y s = take (y-x+1) (drop x s)
