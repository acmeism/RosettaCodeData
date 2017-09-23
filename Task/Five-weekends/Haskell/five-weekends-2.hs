import Data.Time (Day, fromGregorian, gregorianMonthLength)
import Data.Time.Calendar.WeekDate (toWeekDate)
import Data.List.Split (chunksOf)
import Data.List (intercalate)


-- MONTHS WITH FIVE WEEKENDS --------------------------------------------------
fiveFridayMonths :: Integer -> [(Integer, Int)]
fiveFridayMonths y =
  [1 .. 12] >>=
  \m ->
     [ (y, m)
     | isFriday (fromGregorian y m 1)
     , gregorianMonthLength y m == 31 ]

isFriday :: Day -> Bool
isFriday d =
  let (_, _, day) = toWeekDate d
  in day == 5


-- TEST -----------------------------------------------------------------------
main :: IO ()
main = do
  let years = [1900 .. 2100]
      xs = fiveFridayMonths <$> years
      lean =
        concat $
        zipWith
          (\months year ->
              [ year
              | null months ])
          xs
          years
      n = (length . concat) xs
  (putStrLn . intercalate "\n\n")
    [ "How many five-weekend months 1900-2100 ?"
    , '\t' : show n
    , "First five ?"
    , '\t' : show (concat (take 5 xs))
    , "Last five ?"
    , '\t' : show (concat (drop (n - 5) xs))
    , "How many lean years ? (No five-weekend months)"
    , '\t' : show (length lean)
    , "Which years are lean ?"
    , unlines (('\t' :) <$> fmap (unwords . fmap show) (chunksOf 5 lean))
    ]
