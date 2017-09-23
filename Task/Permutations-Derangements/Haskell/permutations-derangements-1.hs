import Control.Monad (forM_)

import Data.List (permutations)

-- Compute all derangements of a list
derangements
  :: Eq a
  => [a] -> [[a]]
derangements = (\x -> filter (and . zipWith (/=) x)) <*> permutations

-- Compute the number of derangements of n elements
subfactorial
  :: (Eq a, Num a)
  => a -> a
subfactorial 0 = 1
subfactorial 1 = 0
subfactorial n = (n - 1) * (subfactorial (n - 1) + subfactorial (n - 2))

main :: IO ()
main
-- Generate and show all the derangements of four integers
 = do
  print $ derangements [1 .. 4]
  putStrLn ""
  -- Print the count of derangements vs subfactorial
  forM_ [1 .. 9] $
    \i ->
       putStrLn $
       mconcat
         [show (length (derangements [1 .. i])), " ", show (subfactorial i)]
  putStrLn ""
  -- Print the number of derangements in a list of 20 items
  print $ subfactorial 20
