import Control.Monad.Random (getRandomR)
import Graphics.Gloss

main = do x <- getRandomR (0,1)
          y <- getRandomR (0,1)
          pts <- gameOfChaos 500000 triangle (x,y)
          display window white $ foldMap point pts
            where window = InWindow "Game of Chaos" (400,400) (0,0)
                  point (x,y) = translate (100*x) (100*y) $ circle 0.02
