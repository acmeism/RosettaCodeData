digits base = Data.List.unfoldr modDiv
  where modDiv 0 = Nothing
        modDiv n = let (q, r) = (n `divMod` base) in Just (r, q)
