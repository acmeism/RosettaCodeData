import Control.Monad.Random
import Control.Monad
import Text.Printf

randN :: MonadRandom m => Int -> m Int
randN n = fromList [(0, fromIntegral n-1), (1, 1)]
