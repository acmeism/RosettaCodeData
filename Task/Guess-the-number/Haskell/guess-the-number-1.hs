import Control.Monad
import System.Random

-- Repeat the action until the predicate is true.
until_ act pred = act >>= pred >>= flip unless (until_ act pred)

answerIs ans guess
    | ans == guess = putStrLn "You got it!" >> return True
    | otherwise = putStrLn "Nope. Guess again." >> return False

ask = liftM read getLine

main = do
  ans <- randomRIO (1,10) :: IO Int
  putStrLn "Try to guess my secret number between 1 and 10."
  ask `until_` answerIs ans
