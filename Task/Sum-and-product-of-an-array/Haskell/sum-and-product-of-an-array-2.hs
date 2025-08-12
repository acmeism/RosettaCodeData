main :: IO ()
main =
  mapM_ print $
    [ foldr (+) 0,
      foldr (*) 1
    ] <*> [[1 .. 10]]
