import Data.List (sortBy)
import Data.Char (toLower)
import Data.Ord (comparing)
import Data.Monoid

-- the Ordering instance of mappend is defined to yield
-- lexicographical ordering.
-- instance Monoid Ordering where
--        mempty         = EQ
--        LT `mappend` _ = LT
--        EQ `mappend` y = y
--        GT `mappend` _ = GT

xs :: [String]
xs = ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"]

lowerCase :: String -> String
lowerCase = (toLower <$>)

main :: IO ()
main =
  mapM_ putStrLn $
  (unlines . flip sortBy xs) <$>
  [       comparing length  <> comparing lowerCase -- Ascending  length
  , flip (comparing length) <> comparing lowerCase -- Descending length
  ]
