cartProdN :: [[a]] -> [[a]]
cartProdN = foldr (\xs as -> xs >>= (<$> as) . (:)) [[]]
