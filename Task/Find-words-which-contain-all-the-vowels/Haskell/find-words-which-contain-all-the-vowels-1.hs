condition :: String -> Bool
condition s = all (\vow -> count vow s == 1 ) "aeiou"
 where
  count :: Char -> String -> Int
  count letter word = length $ filter ( == letter ) word

main :: IO ( )
main = do
   theLines <- readFile "unixdict.txt"
   let selected = filter condition $ words theLines
   mapM_ putStrLn selected
