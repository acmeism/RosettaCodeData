import Data.Map (fromListWith, toList)

main =
  mapM_ print (toList (fromListWith (+) (flip (,) 1 <$> filter (' ' /=) crypt)))
