import Control.Monad ((<=<))
import Data.List (inits, intersect, maximumBy, tails)
import Data.Ord (comparing)

----------------- LONGEST COMMON SUBSTRING ---------------

longestCommon :: Eq a => [a] -> [a] -> [a]
longestCommon a b =
  let pair [x, y] = (x, y)
   in maximumBy (comparing length) $
        (uncurry intersect . pair) $
          [tail . inits <=< tails] <*> [a, b]

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    longestCommon "testing123testing" "thisisatest"
