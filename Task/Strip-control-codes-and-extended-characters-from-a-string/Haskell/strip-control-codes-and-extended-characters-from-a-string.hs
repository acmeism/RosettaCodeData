strip :: String -> String
strip =
  filter
    (\x -- Though use of Data.Char functions like isAlpha, isDigit etc
        -- seems more probable.
       ->
        let o = fromEnum x
        in o > 31 && o < 126)

main :: IO ()
main = print $ strip "alphabetic 字母 with some less parochial parts"
