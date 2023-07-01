import Data.List (genericLength)

-- ARITHMETIC, GEOMETRIC AND HARMONIC MEANS ---------------
arithmetic, geometric, harmonic :: [Double] -> Double
arithmetic = (/) . sum <*> genericLength

geometric = (**) . product <*> ((1 /) . genericLength)

harmonic = (/) . genericLength <*> foldr ((+) . (1 /)) 0

-- TEST ---------------------------------------------------
xs :: [Double]
xs = [arithmetic, geometric, harmonic] <*> [[1 .. 10]]

main :: IO ()
main =
  (putStrLn . unlines)
    [ zip ["Arithmetic", "Geometric", "Harmonic"] xs >>= show
    , mappend "\n A >= G >= H is " $ --
      (show . and) $ zipWith (>=) xs (tail xs)
    ]
