import Data.List ((\\), permutations, nub)
import Control.Monad (join)

missingPerm
  :: Eq a
  => [[a]] -> [[a]]
missingPerm = (\\) =<< permutations . nub . join

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
