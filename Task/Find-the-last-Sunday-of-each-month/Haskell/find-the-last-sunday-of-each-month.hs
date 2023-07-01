import Data.List (find, intercalate, transpose)
import Data.Maybe (fromJust)
import Data.Time.Calendar
  ( Day,
    addDays,
    fromGregorian,
    gregorianMonthLength,
    showGregorian,
  )
import Data.Time.Calendar.WeekDate (toWeekDate)

---------------- LAST SUNDAY OF EACH MONTH ---------------

lastSundayOfEachMonth = lastWeekDayDates 7

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    ( intercalate "  "
        <$> transpose
          (lastSundayOfEachMonth <$> [2013 .. 2017])
    )

------------------- NEAREST DAY OF WEEK ------------------

lastWeekDayDates :: Int -> Integer -> [String]
lastWeekDayDates dayOfWeek year =
  (showGregorian . mostRecentWeekday dayOfWeek)
    . (fromGregorian year <*> gregorianMonthLength year)
    <$> [1 .. 12]

mostRecentWeekday :: Int -> Day -> Day
mostRecentWeekday dayOfWeek date =
  fromJust
    (find p ((`addDays` date) <$> [-6 .. 0]))
  where
    p x =
      let (_, _, day) = toWeekDate x
       in dayOfWeek == day
