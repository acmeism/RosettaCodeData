import Data.List (mapAccumL)

feigenbaumApprox :: Int -> [Double]
feigenbaumApprox mx = snd $ mitch mx 10
  where
    mitch :: Int -> Int -> ((Double, Double, Double), [Double])
    mitch mx mxj =
      mapAccumL
        (\(a1, a2, d1) i ->
            let a =
                  iterate
                    (\a ->
                        let (x, y) =
                              iterate
                                (\(x, y) -> (a - (x * x), 1.0 - ((2.0 * x) * y)))
                                (0.0, 0.0) !!
                              (2 ^ i)
                        in a - (x / y))
                    (a1 + (a1 - a2) / d1) !!
                  mxj
                d = (a1 - a2) / (a - a1)
            in ((a, a1, d), d))
        (1.0, 0.0, 3.2)
        [2 .. (1 + mx)]

-- TEST ------------------------------------------------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
  zipWith
    (\i s -> justifyRight 2 ' ' (show i) ++ '\t' : s)
    [1 ..]
    (show <$> feigenbaumApprox 13)
  where
    justifyRight n c s = drop (length s) (replicate n c ++ s)
