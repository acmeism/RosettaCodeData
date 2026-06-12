import Control.Monad (join)
import Data.List (isSuffixOf)

--------------- NUMBERS WITH STEADY SQUARES --------------

p :: Int -> Bool
p = isSuffixOf . show <*> (show . join (*))


--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    takeWhile (< 10000) $ filter p [0 ..]
