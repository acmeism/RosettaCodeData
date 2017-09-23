import Data.Char (isDigit, isAsciiUpper, ord)

checkSum :: String -> String
checkSum =
  show .
  (`rem` 10) .
  (-) 10 . (`rem` 10) . sum . zipWith (*) [1, 3, 1, 7, 3, 9] . (charValue <$>)

charValue :: Char -> Int
charValue c
  | c `elem` "AEIOU" = error "No vowels."
  | isDigit c = ord c - ord '0'
  | isAsciiUpper c = ord c - ord 'A' + 10

-- TEST ----------------------------------------------------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . ((++) <*> checkSum))
    [ "710889"
    , "B0YBKJ"
    , "406566"
    , "B0YBLH"
    , "228276"
    , "B0YBKL"
    , "557910"
    , "B0YBKR"
    , "585284"
    , "B0YBKT"
    , "B00030"
    ]
