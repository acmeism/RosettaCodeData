cartProd :: [a] -> [b] -> [(a, b)]
cartProd = (<*>) . fmap (,)
