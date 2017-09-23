fromRoman :: String -> Int
fromRoman =
  snd .
  foldr
    (\l (r, n) ->
        ( l
        , (if l >= r
             then (+)
             else (-))
            n
            l))
    (0, 0) .
  fmap evalRomanDigit
