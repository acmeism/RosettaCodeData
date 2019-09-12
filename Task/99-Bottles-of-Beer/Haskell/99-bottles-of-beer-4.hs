location, distribution, solution :: String
[location, distribution, solution] =
  [ "on the wall"
  , "Take one down, pass it around"
  , "Better go to the store to buy some more"
  ]

asset :: Int -> String
asset n =
  let suffix n
        | 1 == n = []
        | otherwise = ['s']
  in unwords [show n, (reverse . concat) $ suffix n : ["elttob"]]

incantation :: Int -> String
incantation n =
  let inventory = unwords . (: [location]) . asset
  in case n of
       0 -> solution
       _ -> unlines [inventory n, asset n, distribution, inventory $ pred n]

main :: IO ()
main = putStrLn $ unlines (incantation <$> [99,98 .. 0])
