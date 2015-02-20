fact :: [Integer]
fact = scanl (*) 1 [1..]

leftFact :: [Integer]
leftFact = scanl (+) 0 fact

main = do
       putStrLn "0 ~ 10:"
       putStrLn $ show $ map (\n -> leftFact !! n) [0..10]
       putStrLn ""

       putStrLn "20 ~ 110 by tens:"
       putStrLn $ unlines $ map show $ map (\n -> leftFact !! n) [20,30..110]
       putStrLn ""

       putStrLn "length of 1,000 ~ 10,000 by thousands:"
       putStrLn $ show $ map (\n -> length $ show $ leftFact !! n) [1000,2000..10000]
       putStrLn ""
