import qualified Data.Text as T

main = do
  putStrLn "PisanoPrime(p,2) for prime p lower than 15"
  putStrLn . see 15 . map (`pisanoPrime` 2) . filter isPrime $ [1 .. 15]
  putStrLn "PisanoPrime(p,1) for prime p lower than 180"
  putStrLn . see 15 . map (`pisanoPrime` 1) . filter isPrime $ [1 .. 180]
  let ns = [1 .. 180] :: [Int]
  let xs = map pisanoPeriod ns
  let ys = map pisano ns
  let zs = map pisanoConjecture ns
  putStrLn "Pisano(m) for m from 1 to 180"
  putStrLn . see 15 $ map pisano [1 .. 180]
  putStrLn $
    "map pisanoPeriod [1..180] == map pisano [1..180] = " ++ show (xs == ys)
  putStrLn $
    "map pisanoPeriod [1..180] == map pisanoConjecture [1..180] = " ++
    show (ys == zs)

bagOf :: Int -> [a] -> [[a]]
bagOf _ [] = []
bagOf n xs =
  let (us, vs) = splitAt n xs
  in us : bagOf n vs

see
  :: Show a
  => Int -> [a] -> String
see n =
  unlines .
  map unwords . bagOf n . map (T.unpack . T.justifyRight 3 ' ' . T.pack . show)

fibMod
  :: Integral a
  => a -> [a]
fibMod 1 = repeat 0
fibMod n = fib
  where
    fib = 0 : 1 : zipWith (\x y -> rem (x + y) n) fib (tail fib)

pisanoPeriod
  :: Integral a
  => a -> a
pisanoPeriod m
  | m <= 0 = 0
pisanoPeriod 1 = 1
pisanoPeriod m = go 1 (tail $ fibMod m)
  where
    go t (0:1:_) = t
    go t (_:xs) = go (succ t) xs

powMod
  :: Integral a
  => a -> a -> a -> a
powMod _ _ k
  | k < 0 = error "negative power"
powMod m _ _
  | 1 == abs m = 0
powMod m p k
  | 1 == abs p = mod v m
  where
    v
      | 1 == p || even k = 1
      | otherwise = p
powMod m p k = go p k
  where
    to x y = mod (x * y) m
    go _ 0 = 1
    go u 1 = mod u m
    go u i
      | even i = to w w
      | otherwise = to u (to w w)
      where
        w = go u (quot i 2)

-- Fermat primality test
probablyPrime
  :: Integral a
  => a -> Bool
probablyPrime p
  | p < 2 || even p = 2 == p
  | otherwise = 1 == powMod p 2 (p - 1)

primes
  :: Integral a
  => [a]
primes =
  2 :
  3 :
  5 :
  7 :
  [ p
  | p <- [11,13 ..]
  , isPrime p ]

limitDivisor
  :: Integral a
  => a -> a
limitDivisor = floor . (+ 0.05) . sqrt . fromIntegral

isPrime
  :: Integral a
  => a -> Bool
isPrime p
  | not $ probablyPrime p = False
isPrime p = go primes
  where
    stop = limitDivisor p
    go (n:_)
      | stop < n = True
    go (n:ns) = (0 /= rem p n) && go ns
    go [] = True

factor
  :: Integral a
  => a -> [(a, a)]
factor n
  | n <= 1 = []
factor n = go n primes
  where
    fun x d c
      | 0 /= rem x d = (x, c)
      | otherwise = fun (quot x d) d (succ c)
    go 1 _ = []
    go _ [] = []
    go x (d:ds)
      | 0 /= rem x d = go x $ dropWhile ((0 /=) . rem x) ds
    go x (d:ds) =
      let (u, c) = fun (quot x d) d 1
      in (d, c) : go u ds

pisanoPrime
  :: Integral a
  => a -> a -> a
pisanoPrime p k
  | p <= 0 || k < 0 = 0
pisanoPrime p k = pisanoPeriod $ p ^ k

pisano
  :: Integral a
  => a -> a
pisano m
  | m < 1 = 0
pisano 1 = 1
pisano m = foldl1 lcm . map (uncurry pisanoPrime) $ factor m

pisanoConjecture
  :: Integral a
  => a -> a
pisanoConjecture m
  | m < 1 = 0
pisanoConjecture 1 = 1
pisanoConjecture m = foldl1 lcm . map (uncurry pisanoPrime') $ factor m
  where
    pisanoPrime' p k = (p ^ (k - 1)) * pisanoPeriod p
