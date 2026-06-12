import qualified Data.Set as S
import Numeric (showHex)

---- NUMBERS WITH THE SAME DIGIT SET IN DECIMAL AND HEX --

sameDigitSet :: (Integral a, Show a) => a -> [(a, String)]
sameDigitSet n =
  [ (n, h)
    | let h = showHex n "",
      S.fromList h == S.fromList (show n)
  ]

--------------------------- TEST -------------------------
main = do
  print ("decimal", "hex")
  mapM_ print $ [0 .. 100000] >>= sameDigitSet
