import Control.Monad (replicateM)
import Control.Monad.Random (fromList)

type Point = (Float,Float)
type Transformations = [(Point -> Point, Float)] -- weighted transformations

-- realization of the game for given transformations
gameOfChaos :: MonadRandom m => Int -> Transformations -> Point -> m [Point]
gameOfChaos n transformations x = iterateA (fromList transformations) x
  where iterateA f x = scanr ($) x <$> replicateM n f
