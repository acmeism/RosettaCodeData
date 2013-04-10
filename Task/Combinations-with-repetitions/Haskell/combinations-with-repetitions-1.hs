-- Return the combinations, with replacement, of k items from the
-- list.  We ignore the case where k is greater than the length of
-- the list.
combsWithRep 0  _ = [[]]
combsWithRep _ [] = []
combsWithRep k xxs@(x:xs) = map (x:) (combsWithRep (k-1) xxs) ++ combsWithRep k xs

binomial n m = (f n) `div` (f (n - m)) `div` (f m) where
	f n = if n == 0 then 1 else n * f (n - 1)

countCombsWithRep k lst = binomial (k - 1 + length lst) k
-- countCombsWithRep k = length . combsWithRep k

main = do
  print $ combsWithRep 2 ["iced","jam","plain"]
  print $ countCombsWithRep 3 [1..10]
