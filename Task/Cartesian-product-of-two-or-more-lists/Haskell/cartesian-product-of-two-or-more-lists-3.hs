cartProd :: [a] -> [b] -> [(a, b)]
cartProd xs ys = (,) <$> xs <*> ys
