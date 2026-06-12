import Data.List (transpose)

longestCommonSuffix :: [String] -> String
longestCommonSuffix =
  foldr (flip (<>) . return . head) [] .
  takeWhile (all =<< (==) . head) . transpose . fmap reverse

main :: IO ()
main =
  mapM_
    (putStrLn . longestCommonSuffix)
    [ [ "Sunday"
      , "Monday"
      , "Tuesday"
      , "Wednesday"
      , "Thursday"
      , "Friday"
      , "Saturday"
      ]
    , [ "Sondag"
      , "Maandag"
      , "Dinsdag"
      , "Woensdag"
      , "Donderdag"
      , "Vrydag"
      , "Saterdag"
      , "dag"
      ]
    ]
