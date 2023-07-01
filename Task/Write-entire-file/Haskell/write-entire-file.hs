main :: IO ( )
main = do
   putStrLn "Enter a string!"
   str <- getLine
   putStrLn "Where do you want to store this string ?"
   myFile <- getLine
   appendFile myFile str
