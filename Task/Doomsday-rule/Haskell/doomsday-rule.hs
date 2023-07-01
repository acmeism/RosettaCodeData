import Text.Printf

data Date = Date {year :: Int, month :: Int, day :: Int}

instance Show Date where
  show Date {year = y, month = m, day = d} =
    printf "%4d-%02d-%02d" y m d

leap :: Int -> Bool
leap year =
  year `mod` 4 == 0
    && (year `mod` 100 /= 0 || year `mod` 400 == 0)

weekday :: Date -> Int
weekday Date {year = y, month = m, day = d} =
  let doom = (s + t + (t `div` 4) + c_anchor) `mod` 7
      anchor = dooms !! pred m
      c_anchor = (5 * mod c 4 + 2) `mod` 7
      dooms =
        (if leap y then [4, 1] else [3, 7])
          <> [7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
      (c, r) = y `divMod` 100
      (s, t) = r `divMod` 12
   in (doom + d - anchor + 7) `mod` 7

days :: [String]
days = words "Sunday Monday Tuesday Wednesday Thursday Friday Saturday"

dates :: [Date]
dates =
  [ Date {year = 1800, month = 1, day = 6},
    Date {year = 1875, month = 3, day = 29},
    Date {year = 1915, month = 12, day = 7},
    Date {year = 1970, month = 12, day = 23},
    Date {year = 2043, month = 5, day = 14},
    Date {year = 2077, month = 2, day = 12},
    Date {year = 2101, month = 4, day = 2}
  ]

dateAndDay :: Date -> String
dateAndDay d = printf "%s: %s" (show d) (days !! weekday d)

main :: IO ()
main = putStr $ unlines $ map dateAndDay dates
