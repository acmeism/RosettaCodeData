import Data.List(elemIndex)

data Result = Valid | BadCheck | TooLong | TooShort | InvalidContent deriving Show

-- convert a list of Maybe to a Maybe list.
-- result is Nothing if any of values from the original list are Nothing
allMaybe :: [Maybe a] -> Maybe [a]
allMaybe = sequence

toValue :: Char -> Maybe Int
toValue c = elemIndex c $ ['0'..'9'] ++ ['A'..'Z'] ++ "*@#"

-- check a list of ints to see if they represent a valid CUSIP
valid :: [Int] -> Bool
valid ns0 =
    let -- multiply values with even index by 2
        ns1 = zipWith (\i n -> (if odd i then n else 2*n)) [1..] $ take 8 ns0

        -- apply div/mod formula from site and sum up results
        sm = sum $ fmap (\s -> ( s `div` 10 ) + s `mod` 10) ns1

    in  -- apply mod/mod formula from site and compare to last value in list
        ns0!!8 == (10 - (sm `mod` 10)) `mod` 10

-- check a String to see if it represents a valid CUSIP
checkCUSIP :: String -> Result
checkCUSIP cs
       | l < 9     = TooShort
       | l > 9     = TooLong
       | otherwise = case allMaybe (fmap toValue cs) of
                         Nothing -> InvalidContent
                         Just ns -> if valid ns then Valid else BadCheck
    where l = length cs

testData =
    [ "037833100"
    , "17275R102"
    , "38259P508"
    , "594918104"
    , "68389X106"
    , "68389X105"
    ]

main = mapM_ putStrLn (fmap (\s -> s ++ ": " ++ show (checkCUSIP s)) testData)
