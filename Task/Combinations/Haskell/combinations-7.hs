comb :: Int -> [a] -> [[a]]
comb m xs = combsBySize xs !! m
  where
    combsBySize = foldr f ([[]] : repeat [])
    f x next =
      zipWith
        (<>)
        (fmap (x :) <$> ([] : next))
        next

main :: IO ()
main = print $ comb 3 [0 .. 4]
