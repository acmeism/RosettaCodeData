import Data.Time.Calendar
import Data.Time.Calendar.WeekDate

-- 1 for Monday to 7 for Sunday
findWeekDay dayOfWeek date = head $ filter isWeekDay $ map toDate [-6 .. 0]
  where
    toDate ago = addDays ago date
    isWeekDay theDate = let (_ , _ , day) = toWeekDate theDate
                       in day == dayOfWeek

weekDayDates dayOfWeek year = map (showGregorian . findWeekDay dayOfWeek) lastDaysInMonth
  where
    lastDaysInMonth = map findLastDay [1 .. 12]
    findLastDay month = fromGregorian year month (gregorianMonthLength year month)

sundayDates = weekDayDates 7
main = readLn >>= mapM_ putStrLn.sundayDates
