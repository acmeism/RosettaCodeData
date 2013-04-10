import Data.Time
import Data.Time.Calendar.WeekDate

isXmasSunday year = wday == 7
    where (_,_,wday) = toWeekDate $ fromGregorian year 12 25

main = mapM_ putStrLn ["25 December " ++ show year ++ " is Sunday"
                       | year <- [2008..2121], isXmasSunday year]
