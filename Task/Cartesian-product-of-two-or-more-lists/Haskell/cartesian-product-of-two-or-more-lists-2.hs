cartProd :: [a] -> [b] -> [(a, b)]
cartProd xs ys = xs >>= \x -> ys >>= \y -> [(x, y)]
