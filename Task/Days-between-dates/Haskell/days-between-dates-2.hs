import Data.Time (Day)
import Data.Time.Calendar (diffDays)
import Data.Time.Format (defaultTimeLocale, parseTimeM)

-------------------- DAYS BETWEEN DATES ------------------

daysBetween :: String -> String -> Maybe Integer
daysBetween s1 s2 =
  dayFromString s2
    >>= \d2 -> diffDays d2 <$> dayFromString s1

dayFromString :: String -> Maybe Day
dayFromString =
  parseTimeM
    True
    defaultTimeLocale
    "%Y-%-m-%-d"

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . uncurry showDateDiff)
    [ ("2019-01-01", "2019-09-30"),
      ("2015-12-31", "2016-09-30")
    ]

showDateDiff :: String -> String -> String
showDateDiff s1 s2 =
  maybe
    (unlines ["Unparseable as date string pair:", s1, s2])
    ( \n ->
        concat
          [ "There are ",
            show n,
            " days between ",
            s1,
            " and ",
            s2,
            "."
          ]
    )
    $ daysBetween s1 s2
