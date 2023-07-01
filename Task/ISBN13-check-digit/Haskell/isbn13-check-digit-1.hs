import Data.Char (digitToInt, isDigit)
import Text.Printf (printf)

pair :: Num a => [a] -> [(a, a)]
pair [] = []
pair xs = p (take 2 xs) : pair (drop 2 xs)
  where
    p ps = case ps of
      (x : y : zs) -> (x, y)
      (x : zs) -> (x, 0)

validIsbn13 :: String -> Bool
validIsbn13 isbn
  | length (digits isbn) /= 13 = False
  | otherwise = calc isbn `rem` 10 == 0
  where
    digits = map digitToInt . filter isDigit
    calc = sum . map (\(x, y) -> x + y * 3) . pair . digits

main :: IO ()
main =
  mapM_
    (printf "%s: Valid: %s\n" <*> (show . validIsbn13))
    [ "978-1734314502",
      "978-1734314509",
      "978-1788399081",
      "978-1788399083"
    ]
