import Control.Monad (forM_)
import Data.List (intercalate, mapAccumR)
import System.Environment (getArgs)
import Text.Printf (printf)
import Text.Read (readMaybe)

reduceBy :: Integral a => a -> [a] -> [a]
n `reduceBy` xs = n' : ys where (n', ys) = mapAccumR quotRem n xs

-- Duration/label pairs.
durLabs :: [(Integer, String)]
durLabs = [(undefined, "wk"), (7, "d"), (24, "hr"), (60, "min"), (60, "sec")]

-- Time broken down into non-zero durations and their labels.
compdurs :: Integer -> [(Integer, String)]
compdurs t = let ds = t `reduceBy` (map fst $ tail durLabs)
             in filter ((/=0) . fst) $ zip ds (map snd durLabs)

-- Compound duration of t seconds.  The argument is assumed to be positive.
compoundDuration :: Integer -> String
compoundDuration = intercalate ", " . map (uncurry $ printf "%d %s") . compdurs

main :: IO ()
main = do
  args <- getArgs
  forM_ args $ \arg -> case readMaybe arg of
    Just n  -> printf "%7d seconds = %s\n" n (compoundDuration n)
    Nothing -> putStrLn $ "Invalid number of seconds: " ++ arg
