versions :: [[Int] -> Int]
versions =
  [ sum . fmap (^ 2)      -- ver 1
  , sum . ((^ 2) <$>)     -- ver 2
  , foldr ((+) . (^ 2)) 0 -- ver 3
  ]

main :: IO ()
main =
  mapM_ print ((`fmap` [[3, 1, 4, 1, 5, 9], [1 .. 6], [], [1]]) <$> versions)
