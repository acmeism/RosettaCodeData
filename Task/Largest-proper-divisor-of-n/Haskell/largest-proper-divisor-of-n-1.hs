import Data.List.Split (chunksOf)
import Text.Printf (printf)

lpd :: Int -> Int
lpd 1 = 1
lpd n = head [x | x <- [n -1, n -2 .. 1], n `mod` x == 0]

main :: IO ()
main =
  (putStr . unlines . map concat . chunksOf 10) $
     printf "%3d" . lpd <$> [1 .. 100]
