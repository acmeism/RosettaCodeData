import Data.List     (sort, unfoldr)
import Control.Monad (guard)

gapful :: Int -> Bool
gapful n = n `rem` firstLastDigit n == 0
 where
  firstLastDigit = (\xs -> head xs * 10 + last xs) . reverse
    . unfoldr (\n -> guard (n /= 0) >> pure (n `mod` 10, n `div` 10))

toPalinDrome :: Int -> [Int]
toPalinDrome n = filter ((&&) . (> 100) <*> gapful) [go n n, go n (n `div` 10)]
  where
    go p 0 = p
    go p n'' = go (p * 10 + (n'' `mod` 10)) (n'' `div` 10)

gapfulPalindromes :: [Int]
gapfulPalindromes = (sort . (=<<) toPalinDrome) [1 .. 99999]

endsWith :: Int -> [Int]
endsWith n = filter ((n ==) . (`mod` 10)) gapfulPalindromes

showSets :: (String, [Int] -> [Int]) -> String
showSets (k, r) =
  k ++
  " palindromic gapful numbers ending in:\n" ++
  unlines ((<*>) ((++) . show) ((": " ++) . show . r . endsWith) <$> [1 .. 9])

main :: IO ()
main =
  mapM_
    (putStrLn . showSets)
    [ ("First 20", take 20)
    , ("Last 15 of first 100", drop 85 . take 100)
    , ("Last 10 of first 1000", drop 990 . take 1000)
    ]
