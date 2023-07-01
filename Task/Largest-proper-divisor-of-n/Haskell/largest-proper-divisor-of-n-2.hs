import Data.List (find)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

maxProperDivisors :: Int -> Int
maxProperDivisors n =
  case find ((0 ==) . rem n) [2 .. root] of
    Nothing -> 1
    Just x -> quot n x
  where
    root = (floor . sqrt) (fromIntegral n :: Double)

main :: IO ()
main =
  (putStr . unlines . map concat . chunksOf 10) $
    printf "%3d" . maxProperDivisors <$> [1 .. 100]
