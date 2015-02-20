> import Data.List
> "abc" `isPrefixOf` "abcdefg"
True
> "efg" `isSuffixOf` "abcdefg"
True
> "bcd" `isInfixOf` "abcdefg"
True
> "abc" `isInfixOf` "abcdefg" -- Prefixes and suffixes are also infixes
True
> let infixes a b = findIndices (isPrefixOf a) $ tails b
> infixes "ab" "abcdefabqqab"
[0,6,10]
