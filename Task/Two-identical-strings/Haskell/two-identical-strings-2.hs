import Control.Monad (join)
import Data.Char (digitToInt, intToDigit)
import Numeric (showIntAtBase)


------ CONCATENATION OF TWO IDENTICAL BINARY STRINGS -----

binaryTwin :: Int -> (Int, String)
binaryTwin = ((,) =<< readBinary) . join (<>) showBinary

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ print $
    takeWhile ((1000 >) . fst) $
      binaryTwin <$> [1 ..]

------------------------- GENERIC ------------------------

showBinary :: Int -> String
showBinary = flip (showIntAtBase 2 intToDigit) []

readBinary :: String -> Int
readBinary s =
  snd $
    foldr
      (\c (e, n) -> (2 * e, digitToInt c * e + n))
      (1, 0)
      s
