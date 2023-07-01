import Data.Numbers.Primes (primes)

isBrazil :: Int -> Bool
isBrazil n = 7 <= n && (even n || any (monoDigit n) [2 .. n - 2])

monoDigit :: Int -> Int -> Bool
monoDigit n b =
  let (q, d) = quotRem n b
  in d ==
     snd
       (until
          (uncurry (flip ((||) . (d /=)) . (0 ==)))
          ((`quotRem` b) . fst)
          (q, d))

main :: IO ()
main =
  mapM_
    (\(s, xs) ->
        (putStrLn . concat)
          [ "First 20 "
          , s
          , " Brazilians:\n"
          , show . take 20 $ filter isBrazil xs
          , "\n"
          ])
    [([], [1 ..]), ("odd", [1,3 ..]), ("prime", primes)]
