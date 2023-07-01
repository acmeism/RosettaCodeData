applyN :: Int -> (a -> a) -> a -> a
applyN n f = foldr (.) id (replicate n f)

main :: IO ()
main = print $ applyN 10 (\x -> 2 * x) 1
