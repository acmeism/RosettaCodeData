import System
import Random
import Data.List
import Data.Ord
import Data.Array
import Control.Monad
import Control.Arrow

target = "METHINKS IT IS LIKE A WEASEL"
mutateRate = 0.1
popSize = 100
printEvery = 10

alphabet = listArray (0,26) (' ':['A'..'Z'])

randomChar = (randomRIO (0,26) :: IO Int) >>= return . (alphabet !)

origin = mapM createChar target
    where createChar c = randomChar

fitness = length . filter id . zipWith (==) target

mutate = mapM mutateChar
    where mutateChar c = do
            r <- randomRIO (0.0,1.0) :: IO Double
            if r < mutateRate then randomChar else return c

converge n parent = do
    if n`mod`printEvery == 0 then putStrLn fmtd else return ()
    if target == parent
        then putStrLn $ "\nFinal: " ++ fmtd
        else mapM mutate (replicate (popSize-1) parent) >>=
                converge (n+1) . fst . maximumBy (comparing snd) . map (id &&& fitness) . (parent:)
    where fmtd = parent ++ ": " ++ show (fitness parent) ++ " (" ++ show n ++ ")"

main = origin >>= converge 0
