import System.Time
       (getClockTime, toCalendarTime, formatCalendarTime)

import System.Locale (defaultTimeLocale)

main :: IO ()
main = do
  ct <- getClockTime
  print ct -- print default format, or
  cal <- toCalendarTime ct
  putStrLn $ formatCalendarTime defaultTimeLocale "%a %b %e %H:%M:%S %Y" cal
