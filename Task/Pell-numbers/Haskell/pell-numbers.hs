import Data.Numbers.Primes (isPrime)

----------------------- PELL SERIES ----------------------

pell :: Integer -> Integer -> [Integer]
pell a b = a : b : zipWith (+) (pell a b) ((2 *) <$> tail (pell a b))

a000129, a002203, a001333, a086383, a096650, a002315 :: [Integer]
a000129 = pell 0 1

a002203 = pell 2 2

a001333 = (`div` 2) <$> a002203

a086383 = filter isPrime a000129

a096650 = zip [0 ..] a000129 >>= (\(i, n) -> [i | isPrime n])

a002315 = 1 : 7 : zipWith (-) ((6 *) <$> tail a002315) a002315


------------------- PYTHAGOREAN TRIPLES ------------------

pythagoreanTriples :: [(Integer, Integer, Integer)]
pythagoreanTriples =
  (tail . concat) $ zipWith3 go [0 ..] a000129 (scanl (+) 0 a000129)
  where
    go i p m
      | odd i = [(m, succ m, p)]
      | otherwise = []

-------------------------- TESTS -------------------------
main :: IO ()
main = do
  mapM_
    (\(k, xs) -> putStrLn ('\n' : k) >> print (take 10 xs))
    [ ("a000129", a000129)
    , ("a002203", a002203)
    , ("a001333", a001333)
      -- Waste of electrical power ?
      -- ("a086383", a086383)
      -- ("a096650", a096650
    , ("a002315", a002315)
    ]

  putStrLn "\nRational approximations to sqrt 2:"
  mapM_ putStrLn $
    (take 10 . tail) $
    zipWith
      (\n d ->
         show n <>
         ('/' : show d) <> " -> " <> show (fromIntegral n / fromIntegral d))
      a001333
      a000129

  putStrLn "\nPythagorean triples:"
  mapM_ print $ take 10 pythagoreanTriples
