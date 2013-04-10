{- Much thanks to brool.com for this nice
and elegant solution.  Using an imported standard library
(Text.Regex), replace a given substring with another -}
strReplace :: String -> String -> String -> String
strReplace old new orig = subRegex (mkRegex old) orig new
