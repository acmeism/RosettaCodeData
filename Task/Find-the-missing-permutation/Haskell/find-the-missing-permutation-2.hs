import Data.List (minimumBy, group, sort, transpose)
import Data.Ord (comparing)

missingPerm
  :: Ord a
  => [[a]] -> [a]
missingPerm = ((head . minimumBy (comparing length) . group . sort) <$>) . transpose

deficientPermsList :: [String]
deficientPermsList =
  [ "ABCD"
  , "CABD"
  , "ACDB"
  , "DACB"
  , "BCDA"
  , "ACBD"
  , "ADCB"
  , "CDAB"
  , "DABC"
  , "BCAD"
  , "CADB"
  , "CDBA"
  , "CBAD"
  , "ABDC"
  , "ADBC"
  , "BDCA"
  , "DCBA"
  , "BACD"
  , "BADC"
  , "BDAC"
  , "CBDA"
  , "DBCA"
  , "DCAB"
  ]

main :: IO ()
main = print $ missingPerm deficientPermsList
