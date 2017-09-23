import Data.Char (toUpper)

import Data.Maybe (fromMaybe)

import Text.Printf (PrintfType, printf)

dirs :: [String]
dirs =
  [ "N"
  , "NbE"
  , "N-NE"
  , "NEbN"
  , "NE"
  , "NEbE"
  , "E-NE"
  , "EbN"
  , "E"
  , "EbS"
  , "E-SE"
  , "SEbE"
  , "SE"
  , "SEbS"
  , "S-SE"
  , "SbE"
  , "S"
  , "SbW"
  , "S-SW"
  , "SWbS"
  , "SW"
  , "SWbW"
  , "W-SW"
  , "WbS"
  , "W"
  , "WbN"
  , "W-NW"
  , "NWbW"
  , "NW"
  , "NWbN"
  , "N-NW"
  , "NbW"
  ]

-- Index between 0 and 31 ->  the corresponding compass point name.
pointName :: Int -> String
pointName = capitalize . concatMap (fromMaybe "?" . fromChar) . (dirs !!)
  where
    fromChar c =
      lookup
        c
        [ ('N', "north")
        , ('S', "south")
        , ('E', "east")
        , ('W', "west")
        , ('b', " by ")
        , ('-', "-")
        ]
    capitalize (c:cs) = toUpper c : cs

-- Degrees -> compass point index between 0 and 31.
pointIndex :: Double -> Int
pointIndex d = (round (d * 1000) + 5625) `mod` 360000 `div` 11250

printPointName :: PrintfType t => String -> t
printPointName d =
  let deg = read d :: Double
      idx = pointIndex deg
  in printf "%2d  %-18s  %6.2f°\n" (idx + 1) (pointName idx) deg

main :: IO ()
main = mapM_ (printPointName . show) [0 .. 31]
