combsWithRep :: Int -> [a] -> [[a]]
combsWithRep k xs = combsBySize xs !! k
  where
    combsBySize = foldr f ([[]] : repeat [])
    f x = scanl1 $ (++) . map (x :)

main :: IO ()
main = print $ combsWithRep 2 ["iced", "jam", "plain"]
