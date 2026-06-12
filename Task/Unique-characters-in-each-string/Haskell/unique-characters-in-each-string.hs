import qualified Data.Map.Strict as M
import Data.Maybe (fromJust)
import qualified Data.Set as S

onceInEach :: [String] -> String
onceInEach [] = []
onceInEach ws@(x : xs) =
  S.elems $
    S.filter
      ((wordCount ==) . fromJust . flip M.lookup freq)
      ( foldr
          (S.intersection . S.fromList)
          (S.fromList x)
          xs
      )
  where
    wordCount = length ws
    freq =
      foldr
        (flip (M.insertWith (+)) 1)
        M.empty
        (concat ws)

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . onceInEach)
    [ "1a3c52debeffd",
      "2b6178c97a938stf",
      "3ycxdb1fgxa2yz"
    ]
