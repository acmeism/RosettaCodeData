{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad
import           Control.Monad.Random
import           Data.Array.Unboxed
import           Data.List
import           Formatting

type Field = UArray (Int, Int) Char

-- Start percolating some seepage through a field.
-- Recurse to continue percolation with spreading seepage.
percolateR :: [(Int, Int)] -> Field -> (Field, [(Int,Int)])
percolateR [] f = (f, [])
percolateR seep f = percolateR
                       (concat $ fmap neighbors validSeep)
                       (f // map (\p -> (p,'.')) validSeep) where
    neighbors p@(r,c) = [(r-1,c), (r+1,c), (r, c-1), (r, c+1)]
    ((rLo,cLo),(rHi,cHi)) = bounds f
    validSeep = filter (\p@(r,c) -> r >= rLo &&
                                    r <= rHi &&
                                    c >= cLo &&
                                    c <= cHi &&
                                    f!p == ' ') $ nub $ sort seep

-- Percolate a field;  Return the percolated field.
percolate :: Field -> Field
percolate start =
    let ((_,_),(_,cHi)) = bounds start
        (final, _) = percolateR [(0,c) | c <- [0..cHi]] start
    in final

-- Generate a random field.
randomField :: Int -> Int -> Double -> Rand StdGen Field
randomField rows cols threshold = do
    rnd <- replicateM rows (replicateM cols $ getRandomR (0.0, 1.0))
    return $ array ((0,0), (rows-1, cols-1))
                    [((r,c), if rnd !! r !! c < threshold then ' '
                             else '#')
                     | r <- [0..rows-1], c <- [0..cols-1] ]

-- Assess whether or not percolation reached bottom of field.
leaky :: Field -> Bool
leaky f = '.' `elem` [f!(rHi,c) | c <- [cLo..cHi]] where
               ((_,cLo),(rHi,cHi)) = bounds f

-- Run test once; Return bool indicating success or failure.
oneTest :: Int -> Int -> Double -> Rand StdGen Bool
oneTest rows cols threshold =
    leaky <$> percolate <$> randomField rows cols threshold

-- Run test multple times; Return the number of tests that pass
multiTest :: Int -> Int -> Int -> Double -> Rand StdGen Double
multiTest repeats rows cols threshold = do
    x <- replicateM repeats $ oneTest rows cols threshold
    let leakyCount = length $ filter (==True) x
    return $ fromIntegral leakyCount / fromIntegral repeats

showField :: Field -> IO ()
showField a =   mapM_ print [ [ a!(r,c) | c <- [cLo..cHi]] | r <- [rLo..rHi]]
              where ((rLo,cLo),(rHi,cHi)) = bounds a

main :: IO ()
main = do
  g <- getStdGen
  let (startField, g2) = runRand (randomField 15 15 0.6) g
  putStrLn "Unpercolated field with 0.6 threshold."
  putStrLn ""
  showField startField

  putStrLn ""
  putStrLn "Same field after percolation."
  putStrLn ""
  showField $ percolate startField

  putStrLn ""
  putStrLn "Results of running percolation test 10000 times with thresholds ranging from 0.0 to 1.0 ."
  let d = 10
  let ns = [0..10]
  let tests = sequence [multiTest 10000 15 15 v
                           | n <- ns,
                             let v = fromIntegral n / fromIntegral d ]
  let results = zip ns (evalRand tests g2)
  mapM_ print [format ("p=" % int % "/" % int % " -> " % fixed 4) n d r | (n,r) <- results]
