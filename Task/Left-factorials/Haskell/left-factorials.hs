leftFact :: [Integer]
leftFact = scanl (+) 0 fact

fact :: [Integer]
fact = scanl (*) 1 [1 ..]

main :: IO ()
main =
  mapM_
    putStrLn
    [ "0 ~ 10:"
    , show $ (leftFact !!) <$> [0 .. 10]
    , ""
    , "20 ~ 110 by tens:"
    , unlines $ show . (leftFact !!) <$> [20,30 .. 110]
    , ""
    , "length of 1,000 ~ 10,000 by thousands:"
    , show $ length . show . (leftFact !!) <$> [1000,2000 .. 10000]
    , ""
    ]
