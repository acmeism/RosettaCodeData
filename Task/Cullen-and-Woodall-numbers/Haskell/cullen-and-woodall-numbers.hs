findCullen :: Int -> Integer
findCullen n = toInteger ( n * 2 ^ n + 1 )

cullens :: [Integer]
cullens = map findCullen [1 .. 20]

woodalls :: [Integer]
woodalls = map (\i -> i - 2 ) cullens

main :: IO ( )
main = do
   putStrLn "First 20 Cullen numbers:"
   print cullens
   putStrLn "First 20 Woodall numbers:"
   print woodalls
