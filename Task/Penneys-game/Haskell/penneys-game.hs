import qualified Data.List as L
import System.IO
import System.Random

data CoinToss = H | T deriving (Read, Show, Eq)

parseToss :: String -> [CoinToss]
parseToss [] = []
parseToss (s:sx)
  | s == 'h' || s == 'H' = H : parseToss sx
  | s == 't' || s == 'T' = T : parseToss sx
  | otherwise = parseToss sx

notToss :: CoinToss -> CoinToss
notToss H = T
notToss T = H

instance Random CoinToss where
  random g = let (b, gb) = random g in (if b then H else T, gb)
  randomR = undefined

prompt :: (Read a) => String -> String -> (String -> Maybe a) -> IO a
prompt msg err parse = do
  putStrLn msg
  line <- getLine
  let ans = parse line
  case ans of
    Nothing   -> do
      putStrLn err
      prompt msg err parse
    Just ansB -> return ansB

showCat :: (Show a) => [a] -> String
showCat = concatMap show

data Winner = Player | CPU

-- This may never terminate.
runToss :: (RandomGen g) => [CoinToss] -> [CoinToss] -> g -> ([CoinToss], Winner)
runToss player cpu gen =
  let stream = randoms gen
      run ss@(s:sx)
        | L.isPrefixOf player ss = player
        | L.isPrefixOf cpu ss    = cpu
        | otherwise              = s : run sx
      winner = run stream
  in if L.isSuffixOf player winner
     then (winner, Player)
     else (winner, CPU)

game :: (RandomGen g, Num a, Show a) => Bool -> a -> a -> g -> IO ()
game cpuTurn playerScore cpuScore gen = do
  putStrLn $ "\nThe current score is CPU: " ++ show cpuScore
    ++ ", You: " ++ show playerScore

  let (genA, genB) = split gen
      promptPlayer check =
        prompt "Pick 3 coin sides: " "Invalid input." $ \s ->
          let tosses = parseToss s in
          if check tosses then Just tosses else Nothing
      promptCpu x  = putStrLn $ "I have chosen: " ++ showCat x

  (tosses, winner) <-
    if cpuTurn
    then do
      let cpuChoice = take 3 $ randoms gen
      promptCpu cpuChoice
      playerChoice <- promptPlayer $ \n -> n /= cpuChoice && 3 == length n
      return $ runToss playerChoice cpuChoice genA
    else do
      playerChoice <- promptPlayer $ \n -> 3 == length n
      let cpuChoice = case playerChoice of [a,b,_] -> [notToss b, a, b]
      promptCpu cpuChoice
      return $ runToss playerChoice cpuChoice genA

  putStrLn $ "The sequence tossed was: " ++ showCat tosses

  case winner of
    Player -> do
      putStrLn "You win!"
      game (not cpuTurn) (playerScore + 1) cpuScore genB
    CPU -> do
      putStrLn "I win!"
      game (not cpuTurn) playerScore (cpuScore + 1) genB

main :: IO ()
main = do
  hSetBuffering stdin LineBuffering
  stdgen <- getStdGen
  let (cpuFirst, genA) = random stdgen
  game cpuFirst 0 0 genA
