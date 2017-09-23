import Data.List (genericLength)

-- ARITHMETIC, GEOMETRIC AND HARMONIC MEANS -----------------------
arithmetic, geometric, harmonic :: [Double] -> Double
arithmetic = liftM2 (/) sum genericLength

geometric = liftM2 (**) product ((1 /) . genericLength)

harmonic = liftM2 (/) genericLength (foldr ((+) . (1 /)) 0)

-- GENERIC --------------------------------------------------------
liftM2 f g h = pure f <*> g <*> h

-- TEST -----------------------------------------------------------
xs :: [Double]
xs = [arithmetic, geometric, harmonic] <*> [[1 .. 10]]

main :: IO ()
main =
  (putStrLn . unlines)
    [ zip ["Arithmetic", "Geometric", "Harmonic"] xs >>= show
    , mappend "\n A >= G >= H is " $ --
      (show . and) $ zipWith (>=) xs (tail xs)
    ]
