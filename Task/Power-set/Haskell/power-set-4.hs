powerSet :: [a] -> [[a]]
powerSet = foldr ((mappend <*>) . fmap . (:)) (pure [])
