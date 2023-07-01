import Data.List (unfoldr)
import Data.Tuple (swap)

step :: Int -> Int
step = sum . map (^ 2) . unfoldr f where
    f 0 = Nothing
    f n = Just . swap $ n `divMod` 10

iter :: Int -> Int
iter = head . filter (`elem` [1, 89]) . iterate step

main = do
    print $ length $ filter ((== 89) . iter) [1 .. 99999999]
