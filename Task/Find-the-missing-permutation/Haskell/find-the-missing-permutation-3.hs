import Data.Char (chr, ord)
import Data.Bits (xor)

missingPerm :: [String] -> String
missingPerm = fmap chr . foldr (zipWith xor . fmap ord) [0, 0, 0, 0]

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
main = putStrLn $ missingPerm deficientPermsList
