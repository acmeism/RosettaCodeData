import Data.Time (fromGregorian)

import Data.Time.Calendar.WeekDate (toWeekDate)

isXmasSunday :: Integer -> Bool
isXmasSunday year =
  let (_, _, wday) = toWeekDate $ fromGregorian year 12 25
  in wday == 7

main :: IO ()
main =
  mapM_
    putStrLn
    [ "25 December " ++ show year ++ " is Sunday"
    | year <- [2008 .. 2121]
    , isXmasSunday year ]
