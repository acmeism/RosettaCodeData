main :: IO ()
main =
  mapM_
    print
    ( fmap
        ($ [1 .. 10])
        [ foldr (+) 0,
          foldr (*) 1
        ]
    )
