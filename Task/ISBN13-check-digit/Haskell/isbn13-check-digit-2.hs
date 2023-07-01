import Data.Char (digitToInt, isDigit)

isISBN13 :: String -> Bool
isISBN13 =
  (0 ==)
    . flip rem 10
    . sum
    . flip
      (zipWith ((*) . digitToInt) . filter isDigit)
      (cycle [1, 3])

main :: IO ()
main =
  mapM_
    (print . ((,) <*> isISBN13))
    [ "978-1734314502",
      "978-1734314509",
      "978-1788399081",
      "978-1788399083"
    ]
