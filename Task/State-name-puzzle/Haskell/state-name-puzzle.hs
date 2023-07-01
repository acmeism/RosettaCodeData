{-# LANGUAGE TupleSections #-}

import Data.Char (isLetter, toLower)
import Data.Function (on)
import Data.List (groupBy, nub, sort, sortBy)

-------------------- STATE NAME PUZZLE -------------------

puzzle :: [String] -> [((String, String), (String, String))]
puzzle states =
  concatMap
    ((filter isValid . pairs) . map snd)
    ( filter ((> 1) . length) $
        groupBy ((==) `on` fst) $
          sortBy
            (compare `on` fst)
            [ (pkey (a <> b), (a, b))
              | (a, b) <- pairs (nub $ sort states)
            ]
    )
  where
    pkey = sort . filter isLetter . map toLower
    isValid ((a0, a1), (b0, b1)) =
      (a0 /= b0)
        && (a0 /= b1)
        && (a1 /= b0)
        && (a1 /= b1)

pairs :: [a] -> [(a, a)]
pairs [] = []
pairs (y : ys) = map (y,) ys <> pairs ys

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn $
    "Matching pairs generated from "
      <> show (length stateNames)
      <> " state names and "
      <> show (length fakeStateNames)
      <> " fake state names:"
  mapM_ print $ puzzle $ stateNames <> fakeStateNames

stateNames :: [String]
stateNames =
  [ "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming"
  ]

fakeStateNames :: [String]
fakeStateNames =
  [ "New Kory",
    "Wen Kory",
    "York New",
    "Kory New",
    "New Kory"
  ]
