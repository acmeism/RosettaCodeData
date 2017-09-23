import System.Random (newStdGen, randomRs)

dataBinCounts :: [Float] -> [Float] -> [Int]
dataBinCounts thresholds range =
  let sampleSize = length range
      xs = ((-) sampleSize . length . flip filter range . (<)) <$> thresholds
  in zipWith (-) (xs ++ [sampleSize]) (0 : xs)

main :: IO ()
main = do
  g <- newStdGen
  let fractions = recip <$> [5 .. 11] :: [Float]
      expected = fractions ++ [1 - sum fractions]
      actual =
        ((/ 1000000.0) . fromIntegral) <$>
        dataBinCounts (scanl1 (+) expected) (take 1000000 (randomRs (0, 1) g))

      piv n = take n . (++ repeat ' ')

  putStrLn "       expected     actual"
  mapM_ putStrLn $
    zipWith3
      (\l s c -> piv 7 l ++ piv 13 (show s) ++ piv 12 (show c))
      ["aleph", "beth", "gimel", "daleth", "he", "waw", "zayin", "heth"]
      expected
      actual
