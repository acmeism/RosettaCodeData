import Data.Time (Day)
import Data.Time.Calendar (diffDays)
import Data.Time.Format (parseTimeM,defaultTimeLocale)

main = do
    putStrLn $ task "2019-01-01" "2019-09-30"
    putStrLn $ task "2015-12-31" "2016-09-30"

task :: String -> String -> String
task xs ys =  "There are " ++ (show $ betweenDays xs ys) ++ " days between " ++ xs ++ " and " ++ ys ++ "."

betweenDays :: String -> String -> Integer
betweenDays date1 date2 = go (stringToDay date1) (stringToDay date2)
    where
    go (Just x) (Just y) = diffDays y x
    go Nothing _ = error "Exception: Bad format first date"
    go _ Nothing = error "Exception: Bad format second date"

stringToDay :: String -> Maybe Day
stringToDay date = parseTimeM True defaultTimeLocale "%Y-%-m-%-d" date
