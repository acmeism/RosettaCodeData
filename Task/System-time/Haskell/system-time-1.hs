import System.Time
import System.Locale

main = do ct <- getClockTime
          print ct                 -- print default format, or
          cal <- toCalendarTime ct
          putStrLn $ formatCalendarTime defaultTimeLocale "%a %b %e %H:%M:%S %Y" cal
