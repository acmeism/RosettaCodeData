import Numeric (readOct, showOct)
import Data.List (intercalate)

to :: Int -> String
to = flip showOct ""

from :: String -> Int
from = fst . head . readOct

main :: IO ()
main =
  mapM_
    (putStrLn .
     intercalate " <-> " . (pure (:) <*> to <*> (return . show . from . to)))
    [2097152, 2097151]
