jacobsthal :: [Integer]
jacobsthal = 0 : 1 : zipWith (\x y -> 2 * x + y) jacobsthal (tail jacobsthal)

jacobsthalLucas :: [Integer]
jacobsthalLucas = 2 : 1 : zipWith (\x y -> 2 * x + y) jacobsthalLucas (tail jacobsthalLucas)

jacobsthalOblong :: [Integer]
jacobsthalOblong = zipWith (*) jacobsthal (tail jacobsthal)

isPrime :: Integer -> Bool
isPrime n = n > 1 && not (or [n `mod` i == 0 | i <- [2 .. floor (sqrt (fromInteger n))]])

main :: IO ()
main = do
  putStrLn "First 30 Jacobsthal numbers:"
  print $ take 30 jacobsthal
  putStrLn ""
  putStrLn "First 30 Jacobsthal-Lucas numbers:"
  print $ take 30 jacobsthalLucas
  putStrLn ""
  putStrLn "First 20 Jacobsthal oblong numbers:"
  print $ take 20 jacobsthalOblong
  putStrLn ""
  putStrLn "First 10 Jacobsthal primes:"
  print $ take 10 $ filter isPrime jacobsthal
