import Control.Monad
import Data.List

-- Compute all derangements of a list
derangements xs = filter (and . zipWith (/=) xs) $ permutations xs

-- Compute the number of derangements of n elements
subfactorial 0 = 1
subfactorial 1 = 0
subfactorial n = (n-1) * (subfactorial (n-1) + subfactorial (n-2))

main = do
  -- Generate and show all the derangements of four integers
  print $ derangements [1..4]
  putStrLn ""

  -- Print the count of derangements vs subfactorial
  forM_ [1..9] $ \i ->
      putStrLn $ show (length (derangements [1..i])) ++ " " ++
                 show (subfactorial i)
  putStrLn ""

  -- Print the number of derangements in a list of 20 items
  print $ subfactorial 20
