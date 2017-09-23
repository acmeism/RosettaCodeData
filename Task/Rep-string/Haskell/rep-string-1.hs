import Data.List (maximumBy, inits)

repstring :: String -> Maybe String
-- empty strings are not rep strings
repstring [] = Nothing
-- strings with only one character are not rep strings
repstring (_:[]) = Nothing
repstring xs
    | any (`notElem` "01") xs = Nothing
    | otherwise = longest xs
    where
        -- length of the original string
        lxs = length xs
        -- half that length
        lq2 = lxs `quot` 2
        -- make a string of same length using repetitions of a part
        -- of the original string, and also return the substring used
        subrepeat x = (x, take lxs $ concat $ repeat x)
        -- check if a repeated string matches the original string
        sndValid (_, ys) = ys == xs
        -- make all possible strings out of repetitions of parts of
        -- the original string, which have max. length lq2
        possible = map subrepeat . take lq2 . tail . inits
        -- filter only valid possibilities, and return the substrings
        -- used for building them
        valid = map fst . filter sndValid . possible
        -- see which string is longer
        compLength a b = compare (length a) (length b)
        -- get the longest substring that, repeated, builds a string
        -- that matches the original string
        longest ys = case valid ys of
            [] -> Nothing
            zs -> Just $ maximumBy compLength zs

main :: IO ()
main = do
    mapM_ processIO examples
    where
        examples = ["1001110011", "1110111011", "0010010010",
            "1010101010", "1111111111", "0100101101", "0100100",
            "101", "11", "00", "1"]
        process = maybe "Not a rep string" id . repstring
        processIO xs = do
            putStr (xs ++ ": ")
            putStrLn $ process xs
