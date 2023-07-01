import Data.Time (isLeapYear)
import Data.Time.Calendar.MonthDay (monthAndDayToDayOfYear)
import Text.Printf (printf)

type Year = Integer
type Day = Int
type Month = Int

data DDate = DDate Weekday Season Day Year
           | StTibsDay Year deriving (Eq, Ord)

data Season = Chaos
            | Discord
            | Confusion
            | Bureaucracy
            | TheAftermath
            deriving (Show, Enum, Eq, Ord, Bounded)

data Weekday = Sweetmorn
             | Boomtime
             | Pungenday
             | PricklePrickle
             | SettingOrange
             deriving (Show, Enum, Eq, Ord, Bounded)

instance Show DDate where
  show (StTibsDay y) = printf "St. Tib's Day, %d YOLD" y
  show (DDate w s d y) = printf "%s, %s %d, %d YOLD" (show w) (show s) d y

fromYMD :: (Year, Month, Day) -> DDate
fromYMD (y, m, d)
  | leap && dayOfYear == 59 = StTibsDay yold
  | leap && dayOfYear >= 60 = mkDDate $ dayOfYear - 1
  | otherwise               = mkDDate dayOfYear
  where
    yold = y + 1166
    dayOfYear = monthAndDayToDayOfYear leap m d - 1
    leap = isLeapYear y

    mkDDate dayOfYear = DDate weekday season dayOfSeason yold
      where
        weekday = toEnum $ dayOfYear `mod` 5
        season = toEnum $ dayOfYear `div` 73
        dayOfSeason = 1 + dayOfYear `mod` 73
