instance Comonad Cycle where
  extract (Cycle _ _ x _) = x
  duplicate x@(Cycle n _ _ _) = fromList $ take n $ iterate shift x
    where shift (Cycle n _ x (r:::rs)) = Cycle n x r rs

step rule  (Cycle _ l x (r:::_)) = rule l x r

runCA rule = iterate (=>> step rule)
