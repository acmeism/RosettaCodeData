import Data.List (intercalate, mapAccumR)

---------------- COMPOUND DURATION STRINGS ---------------

durationString ::
  String ->
  String ->
  Int ->
  Int ->
  [String] ->
  Int ->
  String
durationString
  componentGap
  numberLabelGap
  daysPerWeek
  hoursPerDay
  xs
  n =
    intercalate
      componentGap
      ( foldr
          (timeTags numberLabelGap)
          []
          (zip (weekParts daysPerWeek hoursPerDay n) xs)
      )

timeTags :: String -> (Int, String) -> [String] -> [String]
timeTags numberLabelGap (n, s) xs
  | 0 < n = intercalate numberLabelGap [show n, s] : xs
  | otherwise = xs

weekParts :: Int -> Int -> Int -> [Int]
weekParts daysPerWeek hoursPerDay =
  snd
    . flip
      (mapAccumR byUnits)
      [0, daysPerWeek, hoursPerDay, 60, 60]

byUnits :: Int -> Int -> (Int, Int)
byUnits rest x = (quot (rest - m) u, m)
  where
    (u, m)
      | 0 < x = (x, rem rest x)
      | otherwise = (1, rest)

--------------------------- TEST -------------------------

translation :: String -> Int -> Int -> Int -> String
translation local daysPerWeek hoursPerDay n =
  intercalate "  ->  " $
    [ show,
      durationString
        ", "
        " "
        daysPerWeek
        hoursPerDay
        (words local)
    ]
      <*> [n]

main :: IO ()
main = do
  let names = "wk d hr min sec"
  let tests = [7259, 86400, 6000000]

  putStrLn "Assuming 24 hrs per day:"
  mapM_ (putStrLn . translation names 7 24) tests

  putStrLn "\nor, at 8 hours per day, 5 days per week:"
  mapM_ (putStrLn . translation names 5 8) tests
