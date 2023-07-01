import System.Random
import Control.Monad.State

numRuns        = 10000
numPrisoners   = 100
numDrawerTries = 50
type Drawers   = [Int]
type Prisoner  =  Int
type Prisoners = [Int]

main = do
  gen <- getStdGen
  putStrLn $ "Chance of winning when choosing randomly: "  ++ (show $ evalState runRandomly gen)
  putStrLn $ "Chance of winning when choosing optimally: " ++ (show $ evalState runOptimally gen)


runRandomly :: State StdGen Double
runRandomly =
  let runResults = replicateM numRuns $ do
         drawers <- state $ shuffle [1..numPrisoners]
         allM (\prisoner -> openDrawersRandomly drawers prisoner numDrawerTries) [1..numPrisoners]
   in  ((/ fromIntegral numRuns) . fromIntegral . sum . map fromEnum) `liftM` runResults

openDrawersRandomly :: Drawers -> Prisoner -> Int -> State StdGen Bool
openDrawersRandomly drawers prisoner triesLeft = go triesLeft []
  where go 0 _ = return False
        go triesLeft seenDrawers = do
          try <- state $ randomR (1, numPrisoners)
          case try of
            x | x == prisoner        -> return True
              | x `elem` seenDrawers -> go triesLeft seenDrawers
              | otherwise            -> go (triesLeft - 1) (x:seenDrawers)

runOptimally :: State StdGen Double
runOptimally =
  let runResults = replicateM numRuns $ do
         drawers <- state $ shuffle [1..numPrisoners]
         return $ all (\prisoner -> openDrawersOptimally drawers prisoner numDrawerTries) [1..numPrisoners]
   in  ((/ fromIntegral numRuns) . fromIntegral . sum . map fromEnum) `liftM` runResults

openDrawersOptimally :: Drawers -> Prisoner -> Int -> Bool
openDrawersOptimally drawers prisoner triesLeft = go triesLeft prisoner
  where go 0 _ = False
        go triesLeft drawerToTry =
          let thisDrawer = drawers !! (drawerToTry - 1)
           in if thisDrawer == prisoner then True else go (triesLeft - 1) thisDrawer


-- Haskel stdlib is lacking big time, so here some necessary 'library' functions

-- make a list of 'len' random values in range 'range' from 'gen'
randomLR :: Integral a => Random b => a -> (b, b) -> StdGen -> ([b], StdGen)
randomLR 0 range gen = ([], gen)
randomLR len range gen =
  let (x, newGen) = randomR range gen
      (xs, lastGen) = randomLR (len - 1) range newGen
  in (x : xs, lastGen)


-- shuffle a list by a generator
shuffle :: [a] -> StdGen -> ([a], StdGen)
shuffle list gen = (shuffleByNumbers numbers list, finalGen)
  where
    n = length list
    (numbers, finalGen) = randomLR n (0, n-1) gen
    shuffleByNumbers :: [Int] -> [a] -> [a]
    shuffleByNumbers [] _ = []
    shuffleByNumbers _ [] = []
    shuffleByNumbers (i:is) xs = let (start, x:rest) = splitAt (i `mod` length xs) xs
                                 in x : shuffleByNumbers is (start ++ rest)

-- short-circuit monadic all
allM :: Monad m => (a -> m Bool) -> [a] -> m Bool
allM func [] = return True
allM func (x:xs) = func x >>= \res -> if res then allM func xs else return False
