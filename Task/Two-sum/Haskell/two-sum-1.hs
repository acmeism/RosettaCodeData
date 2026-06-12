twoSum::(Num a,Ord a) => a -> [a] -> [Int]
twoSum num list = sol ls (reverse ls)
  where
  ls = zip list [0..]
  sol [] _ = []
  sol _ [] = []
  sol xs@((x,i):us) ys@((y,j):vs) = ans
    where
    s = x + y
    ans | s == num  = [i,j]
        | j <= i    = []
        | s < num   = sol (dropWhile ((<num).(+y).fst) us) ys
        | otherwise = sol xs $ dropWhile ((num <).(+x).fst) vs

main = print $ twoSum 21 [0, 2, 11, 19, 90]
