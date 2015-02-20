module Rosettatask
   where
import Data.Time.Calendar
import Data.Time.Calendar.WeekDate

findFriday :: Day -> Day
findFriday date = head $ filter isFriday $ map toDate [0, -1 .. -7]
   where
      toDate :: Integer -> Day
      toDate ago = addDays ago date
      isFriday :: Day -> Bool
      isFriday theDate = d == 5
	 where
	    (_ , _ , d ) = toWeekDate theDate

fridayDates :: Integer -> [String]
fridayDates year = map ( showGregorian . findFriday ) lastDaysInMonth
   where
      lastDaysInMonth = map findLastDay [1 .. 12]
      findLastDay month = fromGregorian year month ( gregorianMonthLength
	    year month )

main = do
   putStrLn "Please enter a year!"
   year <- getLine
   mapM_ putStrLn $ fridayDates ( read year )
