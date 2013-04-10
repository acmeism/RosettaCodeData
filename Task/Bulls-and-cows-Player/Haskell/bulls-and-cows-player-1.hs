import Data.List
import Control.Monad
import System.Random (randomRIO)
import Data.Char(digitToInt)

combinationsOf 0 _ = [[]]
combinationsOf _ [] = []
combinationsOf k (x:xs) = map (x:) (combinationsOf (k-1) xs) ++ combinationsOf k xs

player = do
  let ps = concatMap permutations $ combinationsOf 4 ['1'..'9']
  play ps   where

  play ps =
    if null ps then
	putStrLn "Unable to find a solution"
    else do i <- randomRIO(0,length ps - 1)
            let p = ps!!i :: String
	    putStrLn ("My guess is " ++ p) >>  putStrLn "How many bulls and cows?"
	    input <- takeInput
	    let bc = input ::[Int]
		ps' = filter((==sum bc).length. filter id. map (flip elem p))
		    $ filter((==head bc).length. filter id. zipWith (==) p) ps
	    if length ps' == 1 then putStrLn $ "The answer is " ++ head ps'
		else play ps'

  takeInput = do
    inp <- getLine
    let ui = map digitToInt $ take 2 $ filter(`elem` ['0'..'4']) inp
    if sum ui > 4 || length ui /= 2 then
      do putStrLn "Wrong input. Try again"
	 takeInput
	else return ui
