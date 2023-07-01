import System.Random
import System.IO
import System.Exit
import Control.Monad
import Text.Read
import Data.Maybe

promptAgain :: IO Int
promptAgain = do
  putStrLn "Invalid input - must be a number among 1,2 or 3. Try again."
  playerMove

playerMove :: IO Int
playerMove = do
  putStr "Your choice(1 to 3):"
  number <- getLine
  when (number == "q") $ do
    exitWith ExitSuccess
  let n = readMaybe number :: Maybe Int
  x <- if isNothing n
             then promptAgain
             else let val = read number
                   in if (val > 3 || val < 1)
                      then promptAgain
                      else return val
  return x

computerMove :: IO Int
computerMove = do
  x <- randomRIO (1, 3)
  putStrLn $ "Computer move:" ++ (show x)
  return x

gameLoop :: (IO Int, IO Int) -> IO Int
gameLoop moveorder = loop moveorder 0
  where loop moveorder total = do
        number <- fst moveorder
        let total1 = number + total
        putStrLn $ "Running total:" ++ (show total1)
        if total1 >= 21
           then return 0
           else do
             number <- snd moveorder
             let total2 = number + total1
             putStrLn $ "Running total:" ++ (show total2)
             if total2 >= 21
                then return 1
                else loop moveorder total2

main :: IO ()
main = do
  hSetBuffering stdout $ BlockBuffering $ Just 1
  putStrLn "Enter q to quit at any time"
  x <- randomRIO (0, 1) :: IO Int
  let (moveorder, names) = if x == 0
                 then ((playerMove, computerMove), ("Player", "Computer"))
                 else ((computerMove, playerMove), ("Computer", "Player"))
  when (x == 1) $ do
    putStrLn "Computer will start the game"
  y <- gameLoop moveorder
  when (y == 0) $ do
    putStrLn $ (fst names) ++ " has won the game"
  when (y == 1) $ do
    putStrLn $ (snd names) ++ " has won the game"
