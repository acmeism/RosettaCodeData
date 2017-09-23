digit :: Char -> Char -> Char -> Integer -> String
digit x y z k =
  [[x], [x, x], [x, x, x], [x, y], [y], [y, x], [y, x, x], [y, x, x, x], [x, z]] !!
  (fromInteger k - 1)

toRoman :: Integer -> String
toRoman 0 = ""
toRoman x
  | x < 0 = error "Negative roman numeral"
toRoman x
  | x >= 1000 = 'M' : toRoman (x - 1000)
toRoman x
  | x >= 100 = digit 'C' 'D' 'M' q ++ toRoman r
  where
    (q, r) = x `divMod` 100
toRoman x
  | x >= 10 = digit 'X' 'L' 'C' q ++ toRoman r
  where
    (q, r) = x `divMod` 10
toRoman x = digit 'I' 'V' 'X' x

main :: IO ()
main = print $ toRoman <$> [1999, 25, 944]
