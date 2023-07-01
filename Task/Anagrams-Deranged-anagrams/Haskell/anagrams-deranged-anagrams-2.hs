import Control.Monad ((<=<))
import Data.Function (on)
import Data.List (find, groupBy, sort, sortOn)
import Data.Ord (Down (Down))

-------------------- DERANGED ANAGRAMS -------------------

longestDeranged :: [String] -> String
longestDeranged xs =
  case find deranged (longestAnagramPairs xs) of
    Nothing -> "No deranged anagrams found."
    Just (a, b) -> a <> " -> " <> b

deranged :: (String, String) -> Bool
deranged (a, b) = and (zipWith (/=) a b)

longestAnagramPairs :: [String] -> [(String, String)]
longestAnagramPairs = ((<*>) =<< fmap (,)) <=<
  (sortOn (Down . length . head) . anagramGroups)

anagramGroups :: [String] -> [[String]]
anagramGroups xs =
  groupBy
    (on (==) fst)
    (sortOn fst (((,) =<< sort) <$> xs))
    >>= (\g -> [snd <$> g | 1 < length g])


--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= (putStrLn . longestDeranged . lines)
