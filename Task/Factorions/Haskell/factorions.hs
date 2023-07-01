import Text.Printf (printf)
import Data.List (unfoldr)
import Control.Monad (guard)

factorion :: Int -> Int -> Bool
factorion b n = f b n == n
 where
  f b = sum . map (product . enumFromTo 1) . unfoldr (\x -> guard (x > 0) >> pure (x `mod` b, x `div` b))

main :: IO ()
main = mapM_ (uncurry (printf "Factorions for base %2d: %s\n") . (\(a, b) -> (b, result a b)))
  [(3,9), (4,10), (5,11), (2,12)]
 where
  factorions b = filter (factorion b) [1..]
  result n = show . take n . factorions
