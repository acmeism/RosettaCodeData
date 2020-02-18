import Data.Ratio (Ratio, numerator, denominator, (%))
import Data.Bool (bool)

bernouillis :: Integer -> [Rational]
bernouillis = fmap head . tail . scanl faulhaber [] . enumFromTo 0

faulhaber :: [Ratio Integer] -> Integer -> [Ratio Integer]
faulhaber rs n = (:) =<< (-) 1 . sum $ zipWith ((*) . (n %)) [2 ..] rs

-- TEST ---------------------------------------------------
main :: IO ()
main = do
  let xs = bernouillis 60
      w = length (show (numerator (last xs)))
  putStrLn $
    fTable
      "Bernouillis from Faulhaber triangle:\n"
      (show . fst)
      (showRatio w . snd)
      id
      (filter ((0 /=) . snd) $ zip [0 ..] xs)

-- FORMATTING ---------------------------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let w = maximum (length . xShow <$> xs)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs

showRatio :: Int -> Rational -> String
showRatio w r =
  let d = denominator r
  in rjust w ' ' (show (numerator r)) ++ bool [] (" / " ++ show d) (1 /= d)

rjust :: Int -> a -> [a] -> [a]
rjust n c = drop . length <*> (replicate n c ++)
