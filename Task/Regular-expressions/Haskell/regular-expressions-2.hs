ghci> import Text.Regex.TDFA
ghci> compiled = makeRegex ".*string$" :: Regex
ghci> match compiled "I am a string" :: Bool
