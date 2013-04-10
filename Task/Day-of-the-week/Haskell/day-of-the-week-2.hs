import System.Time

isXmasSunday year = ctWDay cal == Sunday
  where cal = toUTCTime $ toClockTime cal'
        cal' = CalendarTime {
                 ctYear = year,
                 ctMonth = December,
                 ctDay = 25,
                 ctHour = 0,
                 ctMin = 0,
                 ctSec = 0,
                 ctPicosec = 0,
                 ctWDay = Friday,
                 ctYDay = 0,
                 ctTZName = "",
                 ctTZ = 0,
                 ctIsDST = False
               }

main = mapM_ putStrLn ["25 December " ++ show year ++ " is Sunday"
                       | year <- [2008..2121], isXmasSunday year]
