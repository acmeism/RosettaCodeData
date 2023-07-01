import Data.Ratio (Ratio, denominator, numerator, (%))

------------------------ FAULHABER -----------------------

faulhaber :: Int -> Rational -> Rational
faulhaber p n =
  sum $
    zipWith ((*) . (n ^)) [1 ..] (faulhaberTriangle !! p)


faulhaberTriangle :: [[Rational]]
faulhaberTriangle =
  tail $
    scanl
      ( \rs n ->
          let xs = zipWith ((*) . (n %)) [2 ..] rs
           in 1 - sum xs : xs
      )
      []
      [0 ..]


--------------------------- TEST -------------------------
main :: IO ()
main = do
  let triangle = take 10 faulhaberTriangle
      widths = maxWidths triangle
  mapM_
    putStrLn
    [ unlines
        ( (justifyRatio widths 8 ' ' =<<)
            <$> triangle
        ),
      (show . numerator) (faulhaber 17 1000)
    ]

------------------------- DISPLAY ------------------------

justifyRatio ::
  (Int, Int) -> Int -> Char -> Rational -> String
justifyRatio (wn, wd) n c nd =
  go $
    [numerator, denominator] <*> [nd]
  where
    -- Minimum column width, or more if specified.
    w = max n (wn + wd + 2)
    go [num, den]
      | 1 == den = center w c (show num)
      | otherwise =
        let (q, r) = quotRem (w - 1) 2
         in concat
              [ justifyRight q c (show num),
                "/",
                justifyLeft (q + r) c (show den)
              ]

justifyLeft :: Int -> a -> [a] -> [a]
justifyLeft n c s = take n (s <> replicate n c)

justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c <>)

center :: Int -> a -> [a] -> [a]
center n c s =
  let (q, r) = quotRem (n - length s) 2
      pad = replicate q c
   in concat [pad, s, pad, replicate r c]

maxWidths :: [[Rational]] -> (Int, Int)
maxWidths xss =
  let widest f xs = maximum $ fmap (length . show . f) xs
   in ((,) . widest numerator <*> widest denominator) $
        concat xss
