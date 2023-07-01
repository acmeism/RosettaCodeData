import Data.Time.Calendar
       (Day, addDays, showGregorian, fromGregorian, gregorianMonthLength)
import Data.Time.Calendar.WeekDate (toWeekDate)
import Data.List (transpose, intercalate)

-- [1 .. 7] for [Mon .. Sun]
findWeekDay :: Int -> Day -> Day
findWeekDay dayOfWeek date =
  head
    (filter
       (\x ->
           let (_, _, day) = toWeekDate x
           in day == dayOfWeek)
       ((`addDays` date) <$> [-6 .. 0]))

weekDayDates :: Int -> Integer -> [String]
weekDayDates dayOfWeek year =
  ((showGregorian . findWeekDay dayOfWeek) .
   (fromGregorian year <*> gregorianMonthLength year)) <$>
  [1 .. 12]

main :: IO ()
main =
  mapM_
    putStrLn
    (intercalate "  " <$> transpose (weekDayDates 5 <$> [2012 .. 2017]))
