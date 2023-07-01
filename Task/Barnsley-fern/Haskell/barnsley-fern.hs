import Data.List (scanl')
import Diagrams.Backend.Rasterific.CmdLine
import Diagrams.Prelude
import System.Random

type Pt  = (Double, Double)

-- Four affine transformations used to produce a Barnsley fern.
f1, f2, f3, f4 :: Pt -> Pt
f1 (x, y) = (                       0,             0.16 * y)
f2 (x, y) = ( 0.85 * x + 0.04 * y    , -0.04 * x + 0.85 * y + 1.60)
f3 (x, y) = ( 0.20 * x - 0.26 * y    ,  0.23 * x + 0.22 * y + 1.60)
f4 (x, y) = (-0.15 * x + 0.28 * y    ,  0.26 * x + 0.24 * y + 0.44)

-- Given a random number in [0, 1) transform an initial point by a randomly
-- chosen function.
func :: Pt -> Double -> Pt
func p r | r < 0.01  = f1 p
         | r < 0.86  = f2 p
         | r < 0.93  = f3 p
         | otherwise = f4 p

-- Using a sequence of uniformly distributed random numbers in [0, 1) return
-- the same number of points in the fern.
fern :: [Double] -> [Pt]
fern = scanl' func (0, 0)

-- Given a supply of random values and a count, generate a diagram of a fern
-- composed of that number of points.
drawFern :: [Double] -> Int -> Diagram B
drawFern rs n = frame 0.5 . diagramFrom . take n $ fern rs
  where diagramFrom = flip atPoints (repeat dot) . map p2
        dot = circle 0.005 # lc green

-- To generate a PNG image of a fern, call this program like:
--
--   fern -o fern.png -w 640 -h 640 50000
--
-- where the arguments specify the width, height and number of points in the
-- image.
main :: IO ()
main = do
  rand <- getStdGen
  mainWith $ drawFern (randomRs (0, 1) rand)
