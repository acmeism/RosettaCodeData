import Math.NumberTheory.Primes (Prime, unPrime, nextPrime)
import Math.NumberTheory.Primes.Testing (isPrime, millerRabinV)
import Text.Printf (printf)

rotated :: [Integer] -> [Integer]
rotated xs
  | any (< head xs) xs = []
  | otherwise          = map asNum $ take (pred $ length xs) $ rotate xs
 where
  rotate [] = []
  rotate (d:ds) = ds <> [d] : rotate (ds <> [d])

asNum :: [Integer] -> Integer
asNum [] = 0
asNum n@(d:ds)
 | all (==1) n = read $ concatMap show n
 | otherwise = (d * (10 ^ length ds)) + asNum ds

digits :: Integer -> [Integer]
digits 0 = []
digits n = digits d <> [r]
 where (d, r) = n `quotRem` 10

isCircular :: Bool -> Integer -> Bool
isCircular repunit n
  | repunit = millerRabinV 0 n
  | n < 10 = True
  | even n = False
  | null rotations = False
  | any (<n) rotations = False
  | otherwise = all isPrime rotations
 where
  rotations = rotated $ digits n

repunits :: [Integer]
repunits = go 2
 where go n = asNum (replicate n 1) : go (succ n)

asRepunit :: Int -> Integer
asRepunit n = asNum $ replicate n 1

main :: IO ()
main = do
  printf "The first 19 circular primes are:\n%s\n\n" $ circular primes
  printf "The next 4 circular primes, in repunit format are:\n"
  mapM_ (printf "R(%d) ") $ reps repunits
  printf "\n\nThe following repunits are probably circular primes:\n"
  mapM_ (uncurry (printf "R(%d) : %s\n") . checkReps) [5003, 9887, 15073, 25031, 35317, 49081]
 where
  primes = map unPrime [nextPrime 1..]
  circular = show . take 19 . filter (isCircular False)
  reps = map (sum . digits). tail . take 5 . filter (isCircular True)
  checkReps = (,) <$> id <*> show . isCircular True . asRepunit
