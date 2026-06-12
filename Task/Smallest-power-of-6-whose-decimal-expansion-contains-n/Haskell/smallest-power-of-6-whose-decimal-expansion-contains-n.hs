import Data.List (find, isInfixOf)
import Text.Printf (printf)

smallest :: Integer -> Integer
smallest n = d
  where
    Just d = find ((show n `isInfixOf`) . show) sixes

sixes :: [Integer]
sixes = iterate (* 6) 1

main :: IO ()
main =
  putStr $
    [0 .. 21] >>= printf "%2d: %d\n" <*> smallest
