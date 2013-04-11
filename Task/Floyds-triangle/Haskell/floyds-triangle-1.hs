import Data.List
import Control.Monad
import Control.Arrow

alignR :: Int -> Integer -> String
alignR n = (\s -> replicate (n - length s) ' ' ++ s). show

floydTriangle = liftM2 (zipWith (liftM2 (.) enumFromTo ((pred.). (+)))) (scanl (+) 1) id [1..]

formatFT n = mapM_ (putStrLn. unwords. zipWith alignR ws) t where
  t = take n floydTriangle
  ws = map (length. show) $ last t
