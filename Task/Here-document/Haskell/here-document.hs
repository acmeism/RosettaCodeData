main :: IO ()
main = do

-- multiline String
  putStrLn "Hello\
            \ World!\n"

-- more haskell-ish way
  putStrLn $ unwords ["This", "is", "an", "example", "text!\n"]

-- now with multiple lines
  putStrLn $ unlines [
             unwords ["This", "is", "the", "first" , "line."]
           , unwords ["This", "is", "the", "second", "line."]
           , unwords ["This", "is", "the", "third" , "line."]
           ]
