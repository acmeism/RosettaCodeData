import Data.Char (isAsciiUpper, isDigit, ord)

-------------------------- SEDOLS ------------------------

checkSum :: String -> String
checkSum x =
  case traverse sedolValue x of
    Right xs -> (show . checkSumFromSedolValues) xs
    Left annotated -> annotated

checkSumFromSedolValues :: [Int] -> Int
checkSumFromSedolValues xs =
  rem
    ( 10
        - rem
          ( sum $
              zipWith
                (*)
                [1, 3, 1, 7, 3, 9]
                xs
          )
          10
    )
    10

sedolValue :: Char -> Either String Int
sedolValue c
  | c `elem` "AEIOU" = Left " ← Unexpected vowel."
  | isDigit c = Right (ord c - ord '0')
  | isAsciiUpper c = Right (ord c - ord 'A' + 10)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . ((<>) <*> checkSum))
    [ "710889",
      "B0YBKJ",
      "406566",
      "B0YBLH",
      "228276",
      "B0YBKL",
      "557910",
      "B0YBKR",
      "585284",
      "B0YBKT",
      "BOYBKT", -- Ill formed test case - illegal vowel.
      "B00030"
    ]
