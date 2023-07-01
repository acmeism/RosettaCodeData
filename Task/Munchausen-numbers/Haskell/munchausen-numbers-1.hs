import Control.Monad (join)
import Data.List (unfoldr)

isMunchausen :: Integer -> Bool
isMunchausen =
  (==)
    <*> (sum . map (join (^)) . unfoldr digit)

digit 0 = Nothing
digit n = Just (r, q) where (q, r) = n `divMod` 10

main :: IO ()
main = print $ filter isMunchausen [1 .. 5000]
