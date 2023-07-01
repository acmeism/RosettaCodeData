scs :: Eq a  => [a] -> [a] -> [a]
scs [] ys = ys
scs xs [] = xs
scs xss@(x:xs) yss@(y:ys)
  | x == y = x : scs xs ys
  | otherwise = ws
      where
      us = scs xs yss
      vs = scs xss ys
      ws  | length us < length vs = x : us
          | otherwise = y : vs

main = putStrLn $ scs "abcbdab" "bdcaba"
