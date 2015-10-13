import System.Environment (getArgs)

-- Pascal's triangle.
pascal :: [[Integer]]
pascal = [1] : map (\row -> 1 : zipWith (+) row (tail row) ++ [1]) pascal

-- The Catalan numbers from Pascal's triangle.  This uses a method from
-- http://www.cut-the-knot.org/arithmetic/algebra/CatalanInPascal.shtml
-- (see "Grimaldi").
catalan :: [Integer]
catalan = map (diff . uncurry drop) $ zip [0..] (alt pascal)
  where alt (x:_:zs) = x : alt zs -- every other element of an infinite list
        diff (x:y:_) = x - y
        diff (x:_)   = x

main :: IO ()
main = do
  ns <- fmap (map read) getArgs :: IO [Int]
  mapM_ (print . flip take catalan) ns
