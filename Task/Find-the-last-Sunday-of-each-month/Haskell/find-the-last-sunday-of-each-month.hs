import Data.Time.Calendar
       (Day, addDays, fromGregorian, gregorianMonthLength, showGregorian)
import Data.Time.Calendar.WeekDate (toWeekDate)
import Data.List (find, intercalate, transpose)
import Data.Maybe (fromJust)

-- [1 .. 7] for [Mon .. Sun]
findWeekDay :: Int -> Day -> Day
findWeekDay dayOfWeek date =
  fromJust $
  find
    (\x ->
        let (_, _, day) = toWeekDate x
        in dayOfWeek == day)
    ((`addDays` date) <$> [-6 .. 0])

weekDayDates :: Int -> Integer -> [String]
weekDayDates dayOfWeek year =
  (showGregorian . findWeekDay dayOfWeek) .
  (fromGregorian year <*> gregorianMonthLength year) <$>
  [1 .. 12]

main :: IO ()
main =
  mapM_
    putStrLn
    (intercalate "  " <$> transpose (weekDayDates 7 <$> [2013 .. 2017]))
