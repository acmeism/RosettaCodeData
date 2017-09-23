combsWithRep
  :: (Eq a)
  => Int -> [a] -> [[a]]
combsWithRep k xs = comb k []
  where
    comb 0 lst = lst
    comb n [] = comb (n - 1) (pure <$> xs)
    comb n peers =
      let nextLayer ys@(h:_) = (: ys) <$> dropWhile (/= h) xs
      in comb (n - 1) (foldMap nextLayer peers)

main :: IO ()
main = do
  print $ combsWithRep 2 ["iced", "jam", "plain"]
  print $ length $ combsWithRep 3 [0 .. 9]
