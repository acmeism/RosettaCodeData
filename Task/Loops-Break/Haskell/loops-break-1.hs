import Control.Monad
import System.Random

loopBreak n k = do
  r <- randomRIO (0,n)
  print r
  unless (r==k) $ do
    print =<< randomRIO (0,n)
    loopBreak n k
