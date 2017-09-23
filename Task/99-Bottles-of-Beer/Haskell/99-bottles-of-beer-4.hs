incant :: Int -> String
incant n =
  let inventory = unwords . (: [locate]) . asset
  in case n of
       0 -> solve
       _ -> unlines [inventory n, asset n, distribute, inventory (n - 1)]

asset :: Int -> String
asset n =
  unwords
    [ show n
    , (reverse . concat) $
      (case n of
         1 -> []
         _ -> ['s']) :
      [drink]
    ]

[locate, distribute, solve, drink] =
  [ "on the wall"
  , "Take one down, pass it around"
  , "Better go to the store to buy some more"
  , "elttob"
  ]

main :: IO ()
main = putStrLn $ unlines (incant <$> [99,98 .. 0])
