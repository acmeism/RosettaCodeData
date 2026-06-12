import Data.Char (toLower)
import Data.Function (on)
import Data.List (groupBy, sortOn, (\\))
import Data.Ord (Down (..))
import qualified Data.Set as S

-- WORDS USING LARGEST SUBSET OF GIVEN SET OF CHARACTERS -

uniqueGlyphCounts :: S.Set Char -> [String] -> [[(String, Int)]]
uniqueGlyphCounts glyphs ws =
  groupBy (on (==) snd) . sortOn (Down . snd) $
    ((,) <*> (S.size . S.intersection glyphs . S.fromList))
      <$> ws

--------------------------- TEST -------------------------
consonants :: S.Set Char
consonants =
  S.fromList $
    ((<>) <*> fmap toLower)
      (['A' .. 'Z'] \\ "AEIOU")

main :: IO ()
main =
  readFile "unixdict.txt"
    >>= mapM_ (mapM_ print)
      . take 1
      . uniqueGlyphCounts consonants
      . lines
