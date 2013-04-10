{- As strings are equivalent to lists
of characters in Haskell, test and
see if the given string is an empty list -}
strIsEmpty :: String -> Bool
strIsEmpty x =
    if x == []
        then True
        else False
