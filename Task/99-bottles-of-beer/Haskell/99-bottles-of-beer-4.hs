location, distribution, solution :: String
[location, distribution, solution] =
  [ "on the wall",
    "Take one down, pass it around",
    "Better go to the store to buy some more"
  ]

incantation :: Int -> String
incantation n
  | 0 == n = solution
  | otherwise =
    unlines
      [ inventory n,
        asset n,
        distribution,
        inventory $ pred n
      ]

inventory :: Int -> String
inventory = unwords . (: [location]) . asset

asset :: Int -> String
asset n =
  let suffix n
        | 1 == n = []
        | otherwise = ['s']
   in unwords
        [show n, (reverse . concat) $ suffix n : ["elttob"]]

main :: IO ()
main = putStrLn $ unlines (incantation <$> [99, 98 .. 0])
