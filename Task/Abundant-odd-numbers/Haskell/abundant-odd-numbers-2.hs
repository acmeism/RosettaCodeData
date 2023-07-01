import Data.List (group, sort)
import Data.Numbers.Primes

abundantTuple :: Int -> [(Int, Int)]
abundantTuple n =
  let x = divisorSum n
   in [(n, x) | n < x]

divisorSum :: Int -> Int
divisorSum = sum . init . divisors

divisors :: Int -> [Int]
divisors =
  foldr
    (flip ((<*>) . fmap (*)) . scanl (*) 1)
    [1]
    . group
    . primeFactors

main :: IO ()
main = do
  putStrLn
    "First 25 abundant odd numbers with their divisor sums:"
  mapM_ print $ take 25 ([1, 3 ..] >>= abundantTuple)
  --
  putStrLn
    "\n1000th odd abundant number with its divisor sum:"
  print $ ([1, 3 ..] >>= abundantTuple) !! 999
  --
  putStrLn
    ( "\nFirst odd abundant number over 10^9, "
        <> "with its divisor sum:"
    )
  let billion = 10 ^ 9 :: Int
  print $
    head
      ( [1 + billion, 3 + billion ..]
          >>= abundantTuple
      )
