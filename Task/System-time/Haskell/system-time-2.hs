import Data.Time (getZonedTime, formatTime, defaultTimeLocale)

main :: IO ()
main = do
  zt <- getZonedTime
  print zt -- print default format, or
  putStrLn $ formatTime defaultTimeLocale "%a %b %e %H:%M:%S %Y" zt
