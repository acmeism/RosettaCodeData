import System.Directory
import System.Time

do ct <- getModificationTime filename
   cal <- toCalendarTime ct
   putStrLn (calendarTimeToString cal)
