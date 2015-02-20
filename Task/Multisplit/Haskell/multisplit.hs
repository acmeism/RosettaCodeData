import Data.List as L
import Data.Maybe

trysplit :: Eq a => [a] -> [[a]] -> Maybe ([a], [a])
trysplit s delims =
  case filter (`L.isPrefixOf` s) delims of
    []    -> Nothing
    (d:_) -> Just (d, fromJust $ L.stripPrefix d s)

multisplit :: (Eq a, Num n) => [a] -> [[a]] -> [([a], [a], n)]
multisplit list delims =
  let ms []       acc pos = [(acc, [], pos)]
      ms l@(s:sx) acc pos =
        case trysplit l delims of
          Nothing       -> ms sx (s:acc) (pos + 1)
          Just (d, sxx) -> (acc, d, pos) : ms sxx [] (pos + L.genericLength d)
  in ms list [] 0

main :: IO ()
main = do
  let test   = "a!===b=!=c"
      delims = ["==", "!=", "="]
      parsed = multisplit test delims
  putStrLn "split string:"
  putStrLn $ L.intercalate "," $ map (\(a, _, _) -> a) parsed
  putStrLn "with [(string, delimiter, offset)]:"
  print parsed
