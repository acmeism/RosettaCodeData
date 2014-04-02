comb :: Int -> [a] -> [[a]]
comb m xs = combsBySize xs !! m
 where
   combsBySize = foldr f ([[]] : repeat [])
   f x next = zipWith (++) (map (map (x:)) ([]:next)) next
