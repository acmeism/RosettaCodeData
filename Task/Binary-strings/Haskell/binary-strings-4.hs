{- This is the most obvious way to
append strings, using the built-in
(++) concatenation operator
Note the same would work to join
any two strings (as 'variables' or
as typed strings -}
strAppend :: String -> String -> String
strAppend x y = x ++ y
