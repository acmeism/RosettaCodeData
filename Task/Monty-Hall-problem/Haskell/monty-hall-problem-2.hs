import Control.Monad.State

play :: Bool -> State StdGen Door
play switch = do
    i <- rand
    let d1 = [Car, Goat, Goat] !! i
    return $ case switch of
        False -> d1
        True  -> case d1 of
            Car  -> Goat
            Goat -> Car
  where rand = do
            g <- get
            let (v, new_g) = randomR (0, 2) g
            put new_g
            return v

cars :: Int -> Bool -> StdGen -> (Int, StdGen)
cars n switch g = (numcars, new_g)
  where numcars = length $ filter (== Car) prize_list
        (prize_list, new_g) = runState (replicateM n (play switch)) g
