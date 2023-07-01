import System.Random (StdGen, getStdGen, randomR)

trials :: Int
trials = 10000

data Door = Car | Goat deriving Eq

play :: Bool -> StdGen -> (Door, StdGen)
play switch g = (prize, new_g)
  where (n, new_g) = randomR (0, 2) g
        d1 = [Car, Goat, Goat] !! n
        prize = case switch of
            False -> d1
            True  -> case d1 of
                Car  -> Goat
                Goat -> Car

cars :: Int -> Bool -> StdGen -> (Int, StdGen)
cars n switch g = f n (0, g)
  where f 0 (cs, g) = (cs, g)
        f n (cs, g) = f (n - 1) (cs + result, new_g)
          where result = case prize of Car -> 1; Goat -> 0
                (prize, new_g) = play switch g

main = do
    g <- getStdGen
    let (switch, g2) = cars trials True g
        (stay, _) = cars trials False g2
    putStrLn $ msg "switch" switch
    putStrLn $ msg "stay" stay
  where msg strat n = "The " ++ strat ++ " strategy succeeds " ++
            percent n ++ "% of the time."
        percent n = show $ round $
            100 * (fromIntegral n) / (fromIntegral trials)
