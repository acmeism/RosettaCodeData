fromRoman :: String -> Int
fromRoman =
  sum .
  liftM2 (:) fst snd .
  mapAccumR
    (\l r ->
        ( if l <= r
            then r
            else (-r)
        , l))
    0 .
  fmap charVal
