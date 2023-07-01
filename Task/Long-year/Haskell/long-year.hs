import Data.Time.Calendar (fromGregorian)
import Data.Time.Calendar.WeekDate (toWeekDate)

longYear :: Integer -> Bool
longYear y =
  let (_, w, _) = toWeekDate $ fromGregorian y 12 28
   in 52 < w

main :: IO ()
main = mapM_ print $ filter longYear [2000 .. 2100]
