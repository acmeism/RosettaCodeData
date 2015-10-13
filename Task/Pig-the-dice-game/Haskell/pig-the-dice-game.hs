import System.Random (randomRIO)

data Score = Score { stack :: Int, score :: Int }

main :: IO ()
main = loop (Score 0 0) (Score 0 0)

loop :: Score -> Score -> IO ()
loop p1 p2 = do
  putStrLn $ "\nPlayer 1 ~ " ++ show (score p1)
  p1' <- askPlayer p1
  if (score p1') >= 100
    then putStrLn "P1 won!"
    else do
      putStrLn $ "\nPlayer 2 ~ " ++ show (score p2)
      p2' <- askPlayer p2
      if (score p2') >= 100
        then putStrLn "P2 won!"
        else loop p1' p2'


askPlayer :: Score -> IO Score
askPlayer (Score stack score) = do
  putStr   "\n(h)old or (r)oll? "
  answer <- getChar
  roll   <- randomRIO (1,6)
  case (answer, roll) of
    ('h', _) -> do
      putStrLn $ "      => Score = " ++ show (stack + score)
      return $ Score 0 (stack + score)
    ('r', 1) -> do
      putStrLn $ " => 1 => Sorry - stack was resetted"
      return $ Score 0 score
    ('r', _) -> do
      putStr $ " => " ++ show roll ++ " => current stack = " ++ show (stack + roll)
      askPlayer $ Score (stack + roll) score
    _        -> do
      putStrLn "\nInvalid input - please try again."
      askPlayer $ Score stack score
