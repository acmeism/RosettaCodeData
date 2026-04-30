import Text.Regex

str = "I am a string"

case matchRegex (mkRegex ".*string$") str of
  Just _  -> putStrLn $ "ends with 'string'"
  Nothing -> return ()
