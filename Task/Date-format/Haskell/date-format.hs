import Data.Time
       (FormatTime, formatTime, defaultTimeLocale, utcToLocalTime,
        getCurrentTimeZone, getCurrentTime)

formats :: FormatTime t => [t -> String]
formats = (formatTime defaultTimeLocale) <$>  ["%F", "%A, %B %d, %Y"]

main :: IO ()
main = do
  t <- pure utcToLocalTime <*> getCurrentTimeZone <*> getCurrentTime
  putStrLn $ unlines (formats <*> pure t)
