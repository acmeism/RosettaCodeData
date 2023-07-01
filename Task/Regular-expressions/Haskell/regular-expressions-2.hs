import Text.Regex

orig = "I am the original string"
result = subRegex (mkRegex "original") orig "modified"
putStrLn $ result
