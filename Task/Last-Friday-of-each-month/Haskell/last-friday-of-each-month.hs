import Data.Time.Calendar
import Data.Time.Calendar.WeekDate

findFriday date = head $ filter isFriday $ map toDate [-6 .. 0]
  where
    toDate ago = addDays ago date
    isFriday theDate = let (_ , _ , day) = toWeekDate theDate
                       in day == 5

fridayDates year = map (showGregorian . findFriday) lastDaysInMonth
  where
    lastDaysInMonth = map findLastDay [1 .. 12]
    findLastDay month = fromGregorian year month (gregorianMonthLength year month)

main = do
  putStrLn "Please enter a year!"
  year <- getLine
  mapM_ putStrLn $ fridayDates (read year)
