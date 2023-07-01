import Data.Time (fromGregorian)
import Data.Time.Calendar.WeekDate (toWeekDate)

--------------------- DAY OF THE WEEK --------------------

isXmasSunday :: Integer -> Bool
isXmasSunday year = 7 == weekDay
  where
    (_, _, weekDay) = toWeekDate $ fromGregorian year 12 25


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    [ "Sunday 25 December " <> show year
      | year <- [2008 .. 2121],
        isXmasSunday year
    ]
