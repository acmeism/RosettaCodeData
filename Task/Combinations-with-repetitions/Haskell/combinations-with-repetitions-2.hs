combsWithRep :: Int -> [a] -> [[a]]
combsWithRep k xs = combsBySize xs !! k
 where
   combsBySize = foldr f ([[]] : repeat [])
   f x next = scanl1 (\z n -> map (x:) z ++ n) next

main = do
  print $ combsWithRep 2 ["iced","jam","plain"]
