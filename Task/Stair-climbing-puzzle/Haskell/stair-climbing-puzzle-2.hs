import Control.Monad.State
import System.Random (StdGen, getStdGen, random)

type Robot = State (Int, StdGen)

step :: Robot Bool
step = do
    (i, g) <- get
    let (succeeded, g') = random g
    put (if succeeded then i + 1 else i - 1, g')
    return succeeded

startingPos = 20 :: Int

main = do
    g <- getStdGen
    putStrLn $ "The robot is at step #" ++ show startingPos ++ "."
    let (endingPos, _) = execState stepUp (startingPos, g)
    putStrLn $ "The robot is at step #" ++ show endingPos ++ "."
