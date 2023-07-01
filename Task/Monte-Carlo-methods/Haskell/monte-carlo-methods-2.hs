import Control.Monad (foldM, (>=>))
import System.Random (randomRIO)
import Data.Functor ((<&>))

------- APPROXIMATION TO PI BY A MONTE CARLO METHOD ------

monteCarloPi :: Int -> IO Double
monteCarloPi n =
  (/ fromIntegral n) . (4 *) . fromIntegral
    <$> foldM go 0 [1 .. n]
  where
    rnd = randomRIO (0, 1) :: IO Double
    go a _ = rnd >>= ((<&>) rnd . f a)
    f a x y
      | 1 > x ** 2 + y ** 2 = succ a
      | otherwise = a

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (monteCarloPi >=> print)
    [1000, 10000, 100000, 1000000]
