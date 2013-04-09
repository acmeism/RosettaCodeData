{- Comparing two given strings and
returning a boolean result using a
simple conditional -}
strCompare :: String -> String -> Bool
strCompare x y =
    if x == y
        then True
        else False
