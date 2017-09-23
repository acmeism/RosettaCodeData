import Data.List (intercalate)

base :: Int
base = 8

to :: Int -> [Int]
to 0 = []
to i = to (div i base) ++ [mod i base]

from :: [Int] -> Int
from = foldl1 ((+) . (base *))

main :: IO ()
main =
  mapM_
    (putStrLn .
     intercalate " <-> " .
     (((:) . concatMap show . to) <*> (return . show . from . to)))
    [2097152, 2097151]
