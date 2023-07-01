import Control.Monad (guard)

palindromic :: Int -> Bool
palindromic n = d == reverse d
 where
  d = show n

gapful :: Int -> Bool
gapful n = n `rem` firstLastDigit == 0
 where
  firstLastDigit = read [head asDigits, last asDigits]
  asDigits = show n

result :: Int -> [Int]
result d = do
  x <- [(d+100),(d+110)..]
  guard $ palindromic x && gapful x
  pure x

showSets :: (Int -> String) -> IO ()
showSets r = go 1
 where
  go n = if n <= 9 then do
    putStrLn (show n ++ ": " ++ r n)
    go (succ n)
    else pure ()

main :: IO ()
main = do
  putStrLn "\nFirst 20 palindromic gapful numbers ending in:"
  showSets (show . take 20 . result)
  putStrLn "\nLast 15 of first 100 palindromic gapful numbers ending in:"
  showSets (show . drop 85 . take 100 . result)
  putStrLn "\nLast 10 of first 1000 palindromic gapful numbers ending in:"
  showSets (show . drop 990 . take 1000 . result)
  putStrLn "\ndone."
