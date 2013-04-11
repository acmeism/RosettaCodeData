import Data.Time
import System.Locale

main = do zt <- getZonedTime
          print zt             -- print default format, or
          putStrLn $ formatTime defaultTimeLocale "%a %b %e %H:%M:%S %Y" zt
