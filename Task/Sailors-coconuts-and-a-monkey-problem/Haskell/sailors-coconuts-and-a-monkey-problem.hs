import Control.Monad ((>=>))
import Data.Maybe (mapMaybe)
import System.Environment (getArgs)

-- Takes the number of sailors and the final number of coconuts. Returns
-- Just the associated initial number of coconuts and Nothing otherwise.
tryFor :: Int -> Int -> Maybe Int
tryFor s = foldr (>=>) pure $ replicate s step
  where
    step n
      | n `mod` (s - 1) == 0 = Just $ n * s `div` (s - 1) + 1
      | otherwise = Nothing

-- Gets the number of sailors from the first command-line argument and
-- assumes 5 as a default if none is given. Then uses tryFor to find the
-- smallest solution.
main :: IO ()
main = do
  args <- getArgs
  let n =
        case args of
          [] -> 5
          s:_ -> read s
      a = head . mapMaybe (tryFor n) $ [n,2 * n ..]
  print a
