import Data.Maybe (isJust, isNothing, fromMaybe)
import Data.Char (toUpper)
import Data.List (sortBy, groupBy)
import Data.Function (on)

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
toKeyString st =
    let mch = map (toKey.toUpper) st
    in if any isNothing mch then Nothing
                            else Just $ map (fromMaybe '!') mch

showTextonym :: [(String,String)] -> IO ()
showTextonym ts = do
    let keyCode = fst $ head ts
    putStrLn $ keyCode ++  " => " ++ concat [w ++ " " | (_,w) <- ts ]

main :: IO()
main = do
    let src = "unixdict.txt"
    contents <- readFile src

    let wordList = lines contents
        keyedList = [(key, word) | (Just key, word) <- filter (isJust.fst) $ zip (map toKeyString wordList) wordList]
        groupedList = groupBy ((==) `on` fst) $  sortBy (compare `on` fst) keyedList
        textonymList = filter ((>1) . length) groupedList

    putStrLn $ "There are " ++ show (length keyedList) ++ " words in " ++ src ++ " which can be represented by the digit key mapping."
    putStrLn $ "They require " ++ show (length groupedList) ++ " digit combinations to represent them."
    putStrLn $ show (length textonymList) ++ " digit combinations represent Textonyms."
    putStrLn ""
    putStrLn "Top 5 in ambiguity:"
    mapM_ showTextonym $ take 5 $ sortBy (flip compare `on` length) textonymList
    putStrLn ""
    putStrLn "Top 5 in length:"
    mapM_ showTextonym $ take 5 $ sortBy (flip compare `on` (length.fst.head)) textonymList
