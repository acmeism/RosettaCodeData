insertAfter a b (c:cs) | a==c = a : b : cs
                       | otherwise = c : insertAfter a b cs
insertAfter _ _ [] = error "Can't insert"
