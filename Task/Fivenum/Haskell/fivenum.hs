import Data.List (sort)

fivenum :: [Double] -> [Double]
fivenum [] = []
fivenum xs
  | l >= 5 =
    fmap
      ( (/ 2)
          . ( (+) . (!!) s
                . floor
                <*> (!!) s . ceiling
            )
          . pred
      )
      [1, q, succ l / 2, succ l - q, l]
  | otherwise = s
  where
    l = realToFrac $ length xs
    q = realToFrac (floor $ (l + 3) / 2) / 2
    s = sort xs

main :: IO ()
main =
  print $
    fivenum
      [ 0.14082834,
        0.09748790,
        1.73131507,
        0.87636009,
        -1.95059594,
        0.73438555,
        -0.03035726,
        1.46675970,
        -0.74621349,
        -0.72588772,
        0.63905160,
        0.61501527,
        -0.98983780,
        -1.00447874,
        -0.62759469,
        0.66206163,
        1.04312009,
        -0.10305385,
        0.75775634,
        0.32566578
      ]
