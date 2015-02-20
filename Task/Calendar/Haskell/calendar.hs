import qualified Data.Text as T
import Data.Time
import Data.Time.Calendar
import Data.Time.Calendar.WeekDate
import Data.List.Split (chunksOf)
import Data.List

data Day = Su | Mo | Tu | We | Th | Fr | Sa
           deriving (Show, Eq, Ord, Enum)

data Month = January | February | March
           | April   | May      | June
           | July    | August   | September
           | October | November | December
             deriving (Show, Eq, Ord, Enum)

monthToInt :: Month -> Int
monthToInt = (+ 1) . fromEnum

dayFromDate :: Integer -> Month -> Int -> Int
dayFromDate year month day = day' `mod` 7
    where (_, _, day') = toWeekDate $ fromGregorian year (monthToInt month) day

nSpaces :: Int -> T.Text
nSpaces n = T.replicate n (T.pack " ")

space :: T.Text
space = nSpaces 1

calMarginWidth = 3

calMargin :: T.Text
calMargin = nSpaces calMarginWidth

calWidth = 20

listMonth :: Integer -> Month -> [T.Text]
listMonth year month = [monthHeader, weekHeader] ++ weeks'
    where
      monthHeader = (T.center calWidth ' ') . T.pack $ show month

      weekHeader = (T.intercalate space) $ map (T.pack . show) [(Su)..]

      monthLength = toInteger $
                    gregorianMonthLength year $
                    monthToInt month

      firstDay = dayFromDate year month 1

      days = replicate firstDay (nSpaces 2) ++
             map ((T.justifyRight 2 ' ') . T.pack . show) [1..monthLength]

      weeks = map (T.justifyLeft calWidth ' ') $
              map (T.intercalate space) $
              chunksOf 7 days

      weeks' = weeks ++ replicate (6 - length weeks) (nSpaces calWidth)

listCalendar :: Integer -> Int -> [[[T.Text]]]
listCalendar year calColumns = (chunksOf calColumns) . (map (listMonth year)) $
                               enumFrom January

calColFromCol :: Int -> Int
calColFromCol columns = c + if r >= calWidth then 1 else 0
    where (c, r) = columns `divMod` (calWidth + calMarginWidth)

colFromCalCol :: Int -> Int
colFromCalCol calCol = calCol * calWidth + ((calCol - 1) * calMarginWidth)

center :: Int -> String -> String
center i a = T.unpack . (T.center i ' ') $ T.pack a

printCal :: [[[T.Text]]] -> IO ()
printCal []     = return ()
printCal (c:cx) = do
  mapM_ (putStrLn . T.unpack) rows
  printCal cx
    where rows = map (T.intercalate calMargin) $ transpose c

printCalendar :: Integer -> Int -> IO ()
printCalendar year columns =
    if columns < 20
    then putStrLn $ "Cannot print less than 20 columns"
    else do
      putStrLn $ center columns' "[Maybe Snoopy]"
      putStrLn $ center columns' $ show year
      putStrLn ""
      printCal $ listCalendar year calcol'
    where
      calcol' = calColFromCol columns

      columns' = colFromCalCol calcol'
