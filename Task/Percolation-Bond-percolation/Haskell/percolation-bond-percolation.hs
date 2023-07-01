{-# LANGUAGE OverloadedStrings #-}
import Control.Monad
import Control.Monad.Random
import Data.Array.Unboxed
import Data.List
import Formatting

data Field = Field { f :: UArray (Int, Int) Char
                   , hWall :: UArray (Int, Int) Bool
                   , vWall :: UArray (Int, Int) Bool
                   }

-- Start percolating some seepage through a field.
-- Recurse to continue percolation with new seepage.
percolateR :: [(Int, Int)] -> Field -> (Field, [(Int,Int)])
percolateR [] (Field f h v) = (Field f h v, [])
percolateR seep (Field f h v) =
    let ((xLo,yLo),(xHi,yHi)) = bounds f
        validSeep = filter (\p@(x,y) ->    x >= xLo
                                        && x <= xHi
                                        && y >= yLo
                                        && y <= yHi
                                        && f!p == ' ') $ nub $ sort seep

        north (x,y) = if v ! (x  ,y  ) then [] else [(x  ,y-1)]
        south (x,y) = if v ! (x  ,y+1) then [] else [(x  ,y+1)]
        west  (x,y) = if h ! (x  ,y  ) then [] else [(x-1,y  )]
        east  (x,y) = if h ! (x+1,y  ) then [] else [(x+1,y  )]
        neighbors (x,y) = north(x,y) ++ south(x,y) ++ west(x,y) ++ east(x,y)

    in  percolateR
            (concatMap neighbors validSeep)
            (Field (f // map (\p -> (p,'.')) validSeep) h v)

-- Percolate a field;  Return the percolated field.
percolate :: Field -> Field
percolate start@(Field f _ _) =
    let ((_,_),(xHi,_)) = bounds f
        (final, _) = percolateR [(x,0) | x <- [0..xHi]] start
    in final

-- Generate a random field.
initField :: Int -> Int -> Double -> Rand StdGen Field
initField width height threshold = do
    let f = listArray ((0,0), (width-1, height-1)) $ repeat ' '

    hrnd <- fmap (<threshold) <$> getRandoms
    let h0 = listArray ((0,0),(width, height-1)) hrnd
        h1 = h0 // [((0,y), True) | y <- [0..height-1]]     -- close left
        h2 = h1 // [((width,y), True) | y <- [0..height-1]] -- close right

    vrnd <- fmap (<threshold) <$> getRandoms
    let v0 = listArray ((0,0),(width-1, height)) vrnd
        v1 = v0 // [((x,0), True) | x <- [0..width-1]]  -- close top

    return $ Field f h2 v1

-- Assess whether or not percolation reached bottom of field.
leaks :: Field -> [Bool]
leaks (Field f _ v) =
    let ((xLo,_),(xHi,yHi)) = bounds f
    in [f!(x,yHi)=='.' && not (v!(x,yHi+1)) | x <- [xLo..xHi]]

-- Run test once; Return bool indicating success or failure.
oneTest :: Int -> Int -> Double -> Rand StdGen Bool
oneTest width height threshold =
    or.leaks.percolate <$> initField width height threshold

-- Run test multple times; Return the number of tests that pass.
multiTest :: Int -> Int -> Int -> Double -> Rand StdGen Double
multiTest testCount width height threshold = do
    results <- replicateM testCount $ oneTest width height threshold
    let leakyCount = length $ filter id results
    return $ fromIntegral leakyCount / fromIntegral testCount

-- Helper function for display
alternate :: [a] -> [a] -> [a]
alternate [] _ = []
alternate (a:as) bs = a : alternate bs as

-- Display a field with walls and leaks.
showField :: Field -> IO ()
showField field@(Field a h v) =  do
    let ((xLo,yLo),(xHi,yHi)) = bounds a
        fLines =  [ [ a!(x,y) | x <- [xLo..xHi]] | y <- [yLo..yHi]]
        hLines =  [ [ if h!(x,y) then '|' else ' ' | x <- [xLo..xHi+1]] | y <- [yLo..yHi]]
        vLines =  [ [ if v!(x,y) then '-' else ' ' | x <- [xLo..xHi]] | y <- [yLo..yHi+1]]
        lattice =  [ [ '+' | x <- [xLo..xHi+1]] | y <- [yLo..yHi+1]]

        hDrawn = zipWith alternate hLines fLines
        vDrawn = zipWith alternate lattice vLines
    mapM_ putStrLn $ alternate vDrawn hDrawn

    let leakLine = [ if l then '.' else ' ' | l <- leaks field]
    putStrLn $ alternate (repeat ' ') leakLine

main :: IO ()
main = do
  g <- getStdGen
  let threshold = 0.45
      (startField, g2) = runRand (initField 10 10 threshold) g

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
  putStrLn ("Results of running percolation test " ++ show testCount ++ " times with thresholds ranging from 0/" ++ show densityCount ++ " to " ++ show densityCount ++ "/" ++ show densityCount ++ " .")
  let densities = [0..densityCount]
  let tests = sequence [multiTest testCount 10 10 v
                           | density <- densities,
                             let v = fromIntegral density / fromIntegral densityCount ]
  let results = zip densities (evalRand tests g2)
  mapM_ print [format ("p=" % int % "/" % int % " -> " % fixed 4) density densityCount x | (density,x) <- results]
