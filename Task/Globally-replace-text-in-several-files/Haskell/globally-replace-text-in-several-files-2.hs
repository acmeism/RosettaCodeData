replace _ _ [] = []
replace a b xx@(x:xs) =
    if isPrefixOf a xx
    then b ++ replace a b (drop (length a) xx)
    else x : replace a b xs
