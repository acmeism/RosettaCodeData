main :: IO ()
main =
  mapM_
    putStrLn
    $ [1, 0.98 .. -1]
      >>= \y ->
        [ [-2, -1.98 .. 0.5]
            >>= \x ->
              [ if (\(a, b) -> a ^ 2 + b ^ 2 < 4)
                  ( foldr
                      ( \_ (u, w) ->
                          (u ^ 2 - w ^ 2 + x, 2 * u * w + y)
                      )
                      (0, 0)
                      [1 .. 500]
                  )
                  then '*'
                  else ' '
              ]
        ]
