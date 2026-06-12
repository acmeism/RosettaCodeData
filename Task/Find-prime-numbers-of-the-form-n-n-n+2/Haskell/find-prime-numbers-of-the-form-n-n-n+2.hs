isPrime :: Int -> Bool
isPrime k = null [ x | x <- [2..m], k `mod` x == 0]
  where m = floor . sqrt . fromIntegral $ k

main :: IO()
main = do
       print . filter isPrime . map (\x -> x^3+2) $ [1..199]
