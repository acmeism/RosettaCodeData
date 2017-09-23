{-# LANGUAGE OverloadedStrings #-}
import Control.Monad
import Control.Monad.Random
import Data.Array.Unboxed
import Data.List
import Formatting

type Field = UArray (Int, Int) Char

-- Start percolating some seepage through a field.
-- Recurse to continue percolation with new seepage.
percolateR :: [(Int, Int)] -> Field -> (Field, [(Int,Int)])
percolateR [] f = (f, [])
percolateR seep f =
    let ((xLo,yLo),(xHi,yHi)) = bounds f
        validSeep = filter (\p@(x,y) ->    x >= xLo
                                        && x <= xHi
                                        && y >= yLo
                                        && y <= yHi
                                        && f!p == ' ') $ nub $ sort seep

        neighbors (x,y) = [(x,y-1), (x,y+1), (x-1,y), (x+1,y)]

    in  percolateR
            (concatMap neighbors validSeep)
            (f // map (\p -> (p,'.')) validSeep)

-- Percolate a field.  Return the percolated field.
percolate :: Field -> Field
percolate start =
    let ((_,_),(xHi,_)) = bounds start
        (final, _) = percolateR [(x,0) | x <- [0..xHi]] start
    in final

-- Generate a random field.
initField :: Int -> Int -> Double -> Rand StdGen Field
initField w h threshold = do
    frnd <- fmap (\rv -> if rv<threshold then ' ' else  '#') <$> getRandoms
    return $ listArray ((0,0), (w-1, h-1)) frnd

-- Get a list of "leaks" from the bottom of a field.
leaks :: Field -> [Bool]
leaks f =
    let ((xLo,_),(xHi,yHi)) = bounds f
    in [f!(x,yHi)=='.'| x <- [xLo..xHi]]

-- Run test once; Return bool indicating success or failure.
oneTest :: Int -> Int -> Double -> Rand StdGen Bool
oneTest w h threshold =
    or.leaks.percolate <$> initField w h threshold

-- Run test multple times; Return the number of tests that pass.
multiTest :: Int -> Int -> Int -> Double -> Rand StdGen Double
multiTest testCount w h threshold = do
    results <- replicateM testCount $ oneTest w h threshold
    let leakyCount = length $ filter id results
    return $ fromIntegral leakyCount / fromIntegral testCount

-- Display a field with walls and leaks.
showField :: Field -> IO ()
showField a =  do
    let ((xLo,yLo),(xHi,yHi)) = bounds a
    mapM_ print [ [ a!(x,y) | x <- [xLo..xHi]] | y <- [yLo..yHi]]

main :: IO ()
main = do
  g <- getStdGen
  let w = 15
      h = 15
      threshold = 0.6
      (startField, g2) = runRand (initField w h threshold) g

  putStrLn ("Unpercolated field with " ++ show threshold ++ " threshold.")
  putStrLn ""
  showField startField

  putStrLn ""
  putStrLn "Same field after percolation."
  putStrLn ""
  showField $ percolate startField

  let testCount = 10000
      densityCount = 10

  putStrLn ""
  putStrLn (   "Results of running percolation test " ++ show testCount
            ++ " times with thresholds ranging from 0/" ++ show densityCount
            ++ " to " ++ show densityCount ++ "/" ++ show densityCount ++ " .")

  let densities = [0..densityCount]
      tests = sequence [multiTest testCount w h v
                           | density <- densities,
                             let v = fromIntegral density / fromIntegral densityCount ]
      results = zip densities (evalRand tests g2)
  mapM_ print [format ("p=" % int % "/" % int % " -> " % fixed 4) density densityCount x | (density,x) <- results]
