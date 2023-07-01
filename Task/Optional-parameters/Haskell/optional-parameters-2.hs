import Data.Maybe (fromMaybe)
-- Use fromMaybe as an operator because its prettier
(//) = flip fromMaybe

sorter :: Maybe String -> Maybe Int -> Maybe Bool -> [[String]] -> [[String]]
sorter ((// "lex") -> cmp)
       ((// 0) -> col)
       ((// False) -> rev) = undefined

main = do
    sorter (Just "foo") (Just 1) (Just True)
    sorter Nothing Nothing Nothing
