---------------------- BABBAGE PAIRS ---------------------

babbagePairs :: [(Integer, Integer)]
babbagePairs =
  [0, 10000 ..]
    >>= \x ->
      ( ((,) <*> (^ 2)) . (x +)
          <$> [264, 5264, 9736, 4736]
      )
        >>= \(a, b) ->
          [ (a, b)
            | ((269696 ==) . flip rem 1000000) b
          ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    ( (\(a, b) -> show a <> " ^2 -> " <> show b)
        <$> take 2000 babbagePairs
    )
