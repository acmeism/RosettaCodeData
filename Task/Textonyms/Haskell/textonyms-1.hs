import Data.Char (toUpper)
import Data.Function (on)
import Data.List (groupBy, sortBy)
import Data.Maybe (fromMaybe, isJust, isNothing)

toKey :: Char -> Maybe Char
toKey ch
  | ch < 'A' = Nothing
  | ch < 'D' = Just '2'
  | ch < 'G' = Just '3'
  | ch < 'J' = Just '4'
  | ch < 'M' = Just '5'
  | ch < 'P' = Just '6'
  | ch < 'T' = Just '7'
  | ch < 'W' = Just '8'
  | ch <= 'Z' = Just '9'
  | otherwise = Nothing

toKeyString :: String -> Maybe String
toKeyString st
  | any isNothing mch = Nothing
  | otherwise = Just $ map (fromMaybe '!') mch
  where
    mch = map (toKey . toUpper) st

showTextonym :: [(String, String)] -> String
showTextonym ts =
  fst (head ts)
    ++ " => "
    ++ concat
      [ w ++ " "
        | (_, w) <- ts
      ]

main :: IO ()
main = do
  let src = "unixdict.txt"
  contents <- readFile src
  let wordList = lines contents
      keyedList =
        [ (key, word)
          | (Just key, word) <-
              filter (isJust . fst) $
                zip (map toKeyString wordList) wordList
        ]
      groupedList =
        groupBy ((==) `on` fst) $
          sortBy (compare `on` fst) keyedList
      textonymList = filter ((> 1) . length) groupedList
  mapM_ putStrLn $
    [ "There are "
        ++ show (length keyedList)
        ++ " words in "
        ++ src
        ++ " which can be represented by the digit key mapping.",
      "They require "
        ++ show (length groupedList)
        ++ " digit combinations to represent them.",
      show (length textonymList) ++ " digit combinations represent Textonyms.",
      "",
      "Top 5 in ambiguity:"
    ]
      ++ fmap
        showTextonym
        ( take 5 $
            sortBy (flip compare `on` length) textonymList
        )
      ++ ["", "Top 5 in length:"]
      ++ fmap
        showTextonym
        (take 5 $ sortBy (flip compare `on` (length . fst . head)) textonymList)
