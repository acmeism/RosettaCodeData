import Data.List (groupBy, intercalate, sort, sortBy)
import qualified Data.Set as S
import Data.Ord (comparing)
import Data.Function (on)

main :: IO ()
main =
  readFile "mitWords.txt" >>= (putStrLn . showGroups . circularWords . lines)

circularWords :: [String] -> [String]
circularWords ws =
  let lexicon = S.fromList ws
  in filter (isCircular lexicon) ws

isCircular :: S.Set String -> String -> Bool
isCircular lex w = 2 < length w && all (`S.member` lex) (rotations w)

rotations :: [a] -> [[a]]
rotations = fmap <$> rotated <*> (enumFromTo 0 . pred . length)

rotated :: [a] -> Int -> [a]
rotated [] _ = []
rotated xs n = zipWith const (drop n (cycle xs)) xs

showGroups :: [String] -> String
showGroups xs =
  unlines $
  intercalate " -> " . fmap snd <$>
  filter
    ((1 <) . length)
    (groupBy (on (==) fst) (sortBy (comparing fst) (((,) =<< sort) <$> xs)))
