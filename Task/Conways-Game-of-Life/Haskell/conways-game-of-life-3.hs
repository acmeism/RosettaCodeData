module Main where
import Data.List

lifeStep :: [(Int, Int)] -> [(Int, Int)]
lifeStep cells = [head g | g <- grouped cells, viable g]
  where grouped = group . sort . concatMap neighbors
        neighbors (x, y) = [(x+dx, y+dy) | dx <- [-1..1], dy <- [-1..1], (dx,dy) /= (0,0)]
        viable [_,_,_] = True
        viable [c,_] = c `elem` cells
        viable _ = False


showWorld :: [(Int, Int)] -> IO ()
showWorld cells = mapM_ putStrLn $ worldToGrid cells
  where worldToGrid cells = [[cellChar (x, y) | x <- [least..greatest]] | y <- [least..greatest]]
        cellChar cell = if cell `elem` cells then '#' else '.'
        (least, greatest) = worldBounds cells

worldBounds cells = (least, greatest)
  where least = min x y
        greatest = max x' y'
        (x, y) = head cells
        (x', y') = last cells

runLife :: Int -> [(Int, Int)] -> IO ()
runLife steps cells = rec (steps - 1) cells
  where rec 0 cells = showWorld cells
        rec s cells = do showWorld cells
                         putStrLn ""
                         rec (s - 1) $ lifeStep cells

glider = [(1, 0), (2, 1), (0, 2), (1, 2), (2, 2)]
blinker = [(1, 0), (1, 1), (1, 2)]

main :: IO ()
main = do
  putStrLn "Glider >> 10"
  putStrLn "------------"
  runLife 10 glider
  putStrLn ""
  putStrLn "Blinker >> 3"
  putStrLn "------------"
  runLife 3 blinker
