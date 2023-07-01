import Data.List (intercalate)
import Data.List.Split (chunksOf)
import Data.Time (Day, fromGregorian, gregorianMonthLength)
import Data.Time.Calendar.WeekDate (toWeekDate)

---------------- MONTHS WITH FIVE WEEKENDS ---------------

fiveFridayMonths :: Integer -> [(Integer, Int)]
fiveFridayMonths y =
  [1 .. 12]
    >>= \m ->
      [ (y, m)
        | isFriday (fromGregorian y m 1),
          31 == gregorianMonthLength y m
      ]

isFriday :: Day -> Bool
isFriday d = 5 == day
  where
    (_, _, day) = toWeekDate d

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let years = [1900 .. 2100]
      xs = fiveFridayMonths <$> years
      lean =
        concat $
          zipWith
            (\months year -> [year | null months])
            xs
            years
      n = (length . concat) xs
  (putStrLn . intercalate "\n\n")
    [ "How many five-weekend months 1900-2100 ?",
      '\t' : show n,
      "First five ?",
      '\t' : show (concat (take 5 xs)),
      "Last five ?",
      '\t' : show (concat (drop (n - 5) xs)),
      "How many lean years ? (No five-weekend months)",
      '\t' : show (length lean),
      "Which years are lean ?",
      unlines $
        ('\t' :) . unwords . fmap show
          <$> chunksOf 5 lean
    ]
