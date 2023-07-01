import Text.Printf (printf)

p :: Int -> Int -> Int
p l n = ([-1 ..] >>= f) !! pred n
  where
    digitCount =
      floor $
        logBase 10 (fromIntegral l :: Float)
    log10pwr = logBase 10 2
    f raised = [ds | l == ds]
      where
        ds =
          floor $
            10
              ** ( snd
                     ( properFraction $
                         log10pwr * realToFrac raised
                     )
                     + realToFrac digitCount
                 )

main :: IO ()
main =
  mapM_
    (\(l, n) -> printf "p(%d, %d) = %d\n" l n (p l n))
    [ (12, 1),
      (12, 2),
      (123, 45),
      (123, 12345),
      (123, 678910)
    ]
