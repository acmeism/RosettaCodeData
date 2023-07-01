import Control.Concurrent
import Data.List
import System.Time

-- Library: ansi-terminal
import System.Console.ANSI

number :: (Integral a) => a -> [String]
number 0 =
  ["██████"
  ,"██  ██"
  ,"██  ██"
  ,"██  ██"
  ,"██████"]
number 1 =
  ["    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"]
number 2 =
  ["██████"
  ,"    ██"
  ,"██████"
  ,"██    "
  ,"██████"]
number 3 =
  ["██████"
  ,"    ██"
  ,"██████"
  ,"    ██"
  ,"██████"]
number 4 =
  ["██  ██"
  ,"██  ██"
  ,"██████"
  ,"    ██"
  ,"    ██"]
number 5 =
  ["██████"
  ,"██    "
  ,"██████"
  ,"    ██"
  ,"██████"]
number 6 =
  ["██████"
  ,"██    "
  ,"██████"
  ,"██  ██"
  ,"██████"]
number 7 =
  ["██████"
  ,"    ██"
  ,"    ██"
  ,"    ██"
  ,"    ██"]
number 8 =
  ["██████"
  ,"██  ██"
  ,"██████"
  ,"██  ██"
  ,"██████"]
number 9 =
  ["██████"
  ,"██  ██"
  ,"██████"
  ,"    ██"
  ,"██████"]

colon :: [String]
colon =
  ["      "
  ,"  ██  "
  ,"      "
  ,"  ██  "
  ,"      "]

newline :: [String]
newline =
  ["\n"
  ,"\n"
  ,"\n"
  ,"\n"
  ,"\n"]

space :: [String]
space =
  [" "
  ," "
  ," "
  ," "
  ," "]

leadingZero :: (Integral a) => a -> [[String]]
leadingZero num =
  let (tens, ones) = divMod num 10
  in [number tens, space, number ones]

fancyTime :: CalendarTime -> String
fancyTime time =
  let hour   = leadingZero $ ctHour time
      minute = leadingZero $ ctMin time
      second = leadingZero $ ctSec time
      nums   = hour ++ [colon] ++ minute ++ [colon] ++ second ++ [newline]
  in concat $ concat $ transpose nums

main :: IO ()
main = do
  time <- getClockTime >>= toCalendarTime
  putStr $ fancyTime time
  threadDelay 1000000
  setCursorColumn 0
  cursorUp 5
  main
