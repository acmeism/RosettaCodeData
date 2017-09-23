import Data.List
import Data.Function (on)

data Person =
  P String
    Int
  deriving (Eq)

instance Show Person where
  show (P name val) = "Person " ++ name ++ " with value " ++ show val

instance Ord Person where
  compare (P a _) (P b _) = compare a b

pVal :: Person -> Int
pVal (P _ x) = x

people :: [Person]
people = [P "Joe" 12, P "Bob" 8, P "Alice" 9, P "Harry" 2]


main :: IO ()
main = do
  mapM_ print $ sort people
  putStrLn []
  mapM_ print $ sortBy (on compare pVal) people
