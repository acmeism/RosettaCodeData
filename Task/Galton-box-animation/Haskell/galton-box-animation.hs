import Data.Map hiding (map, filter)
import Graphics.Gloss
import Control.Monad.Random

data Ball = Ball { position :: (Int, Int), turns :: [Int] }

type World = ( Int           -- number of rows of pins
             , [Ball]        -- sequence of balls
             , Map Int Int ) -- counting bins

updateWorld :: World -> World
updateWorld (nRows, balls, bins)
  | y < -nRows-5  = (nRows, map update bs, bins <+> x)
  | otherwise     = (nRows, map update balls, bins)
  where
    (Ball (x,y) _) : bs = balls

    b <+> x = unionWith (+) b (singleton x 1)

    update (Ball (x,y) turns)
      | -nRows <= y && y < 0 = Ball (x + head turns, y - 1) (tail turns)
      | otherwise            = Ball (x, y - 1) turns

drawWorld :: World -> Picture
drawWorld (nRows, balls, bins) = pictures [ color red ballsP
                                          , color black binsP
                                          , color blue pinsP ]
  where ballsP = foldMap (disk 1) $ takeWhile ((3 >).snd) $ map position balls
        binsP  = foldMapWithKey drawBin bins
        pinsP  = foldMap (disk 0.2) $ [1..nRows] >>= \i ->
                                          [1..i] >>= \j -> [(2*j-i-1, -i-1)]

        disk r pos = trans pos $ circleSolid (r*10)
        drawBin x h = trans (x,-nRows-7)
                    $ rectangleUpperSolid 20 (-fromIntegral h)
        trans (x,y) = Translate (20 * fromIntegral x) (20 * fromIntegral y)

startSimulation :: Int -> [Ball] -> IO ()
startSimulation nRows balls = simulate display white 50 world drawWorld update
  where display = InWindow "Galton box" (400, 400) (0, 0)
        world = (nRows, balls, empty)
        update _ _ = updateWorld

main = evalRandIO balls >>= startSimulation 10
  where balls = mapM makeBall [1..]
        makeBall y = Ball (0, y) <$> randomTurns
        randomTurns = filter (/=0) <$> getRandomRs (-1, 1)
