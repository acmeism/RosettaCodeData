subsum :: Int -> [Int] -> [Int]
subsum w =
  snd . head . filter ((== w) . fst) . (++ [(w, [])]) . foldl s [(0, [])]
  where
    s a x = merge a $ map f a
      where
        f (a, l) = (a + x, l ++ [x])

    -- Keep list of sums sorted and unique.
    merge [] a = a
    merge a [] = a
    merge a@((av, al):as) b@((bv, bl):bs)
      | av < bv = (av, al) : merge as b
      | av == bv = (bv, bl) : merge as bs
      | otherwise = (bv, bl) : merge a bs

items :: [Int]
items = [-61, 1, 32, 373, 311, 249, 311, 32, -92, -185, -433,
 -402, -247, 156, 125, 249, 32, -464, -278, 218, 32, -123,
 -216, 373, -185, -402, 156, -402, -61, -31, 902 ]

main :: IO ()
main = print $ subsum 0 items
