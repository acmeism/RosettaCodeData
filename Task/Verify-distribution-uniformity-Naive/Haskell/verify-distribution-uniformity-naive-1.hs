import System.Random
import Data.List
import Control.Monad
import Control.Arrow

distribCheck :: IO Int -> Int -> Int -> IO [(Int,(Int,Bool))]
distribCheck f n d = do
  nrs <- replicateM n f
  let group  = takeWhile (not.null) $ unfoldr (Just. (partition =<< (==). head)) nrs
      avg    = (fromIntegral n) / fromIntegral (length group)
      ul     = round $ (100 + fromIntegral d)/100 * avg
      ll     = round $ (100 - fromIntegral d)/100 * avg
  return $ map (head &&& (id &&& liftM2 (&&) (>ll)(<ul)).length) group
