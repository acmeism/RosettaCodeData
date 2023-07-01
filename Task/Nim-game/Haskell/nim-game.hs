import Data.Char (isDigit, digitToInt)
import System.IO

prompt :: String
prompt = "How many do you take? 1, 2 or 3? "

getPlayerSelection :: IO Int
getPlayerSelection = do
  hSetBuffering stdin NoBuffering
  c <- getChar
  putChar '\n'
  if isDigit c && digitToInt c <= 3 then
    pure (digitToInt c)
  else do
    putStrLn "Invalid input"
    putStr prompt
    getPlayerSelection

play :: Int -> IO ()
play n = do
  putStrLn $ show n ++ token n ++ " remain."
  if n == 0 then putStrLn "Computer Wins!"
  else do
    putStr prompt
    playerSelection <- getPlayerSelection
    let computerSelection
          | playerSelection > 4 = playerSelection - 4
          | otherwise = 4 - playerSelection
    putStrLn $ "Computer takes " ++ show computerSelection ++ token computerSelection ++ ".\n"
    play (n - computerSelection - playerSelection)
  where token 1 = " token"
        token _ = " tokens"

main :: IO ()
main = play 12
