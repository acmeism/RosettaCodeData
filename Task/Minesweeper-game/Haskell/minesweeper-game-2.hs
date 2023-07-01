module Main

where

import MineSweeper   (Board, Cell (..), Pos, coveredLens, coveredMinedLens,
                      coveredFlaggedLens, xCoordLens, yCoordLens, pos, emptyBoard,
                      groupedByRows, displayCell, isLoss, isWin, exposeMines,
                      openCell, flagCell, mineBoard, totalRows, totalCols)
import Text.Printf   (printf)
import Text.Read     (readMaybe)
import System.IO     (hSetBuffering, stdout, BufferMode(..))
import Control.Monad (join, guard)
import Control.Lens  (lengthOf, filtered, view, preview)

data Command = Open Pos | Flag Pos | Invalid

parseInput :: String -> Command
parseInput s | length input /= 3 = Invalid
             | otherwise         = maybe Invalid command parsedPos
 where
  input     = words s
  parsedPos = do
    x <- readMaybe (input !! 1)
    y <- readMaybe (input !! 2)
    guard (x <= totalCols && y <= totalRows)
    pure (x, y)
  command p = case head input of
    "o" -> Open p
    "f" -> Flag p
    _   -> Invalid

cheat :: Board -> String
cheat = show . fmap (view pos) . filter ((== Just True) . preview coveredMinedLens)

totalMines, totalFlagged, totalCovered :: Board -> Int
totalMines = lengthOf (traverse . coveredMinedLens . filtered (==True))
totalFlagged = lengthOf (traverse . coveredFlaggedLens . filtered (==True))
totalCovered = lengthOf (traverse . coveredLens)

-- IO
drawBoard :: Board -> IO ()
drawBoard b = do
  -- printf "Cheat: %s\n" $ cheat b
  printf "  Mines: %d Covered: %d Flagged: %d\n\n"
    (totalMines b) (totalCovered b) (totalFlagged b)
  printf "%3s" ""
  mapM_ (printf "%3d") $ view xCoordLens <$> head rows
  printf "\n"
  mapM_ (\row -> do
    printf "%3d" $ yCoord row
    mapM_ (printf "%3s" . displayCell) row
    printf "\n" ) rows
 where
  rows   = groupedByRows b
  yCoord = view yCoordLens . head

gameLoop :: Board -> IO ()
gameLoop b
  | isLoss b  = drawBoard (exposeMines b) >> printf "\nYou Lose.\n"
  | isWin b   = drawBoard b >> printf "\nYou Win.\n"
  | otherwise = do
    drawBoard b
    putStr "\nPick a cell: "
    c <- getLine
    case parseInput c of
      Open p  -> gameLoop $ openCell p b
      Flag p  -> gameLoop $ flagCell p b
      Invalid -> gameLoop b

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  drawBoard emptyBoard
  putStr "\nPick a cell: "
  c <- getLine
  case parseInput c of
    Open p -> join $ startGame p emptyBoard
    _      -> main
 where
  startGame p b = gameLoop . openCell p <$> mineBoard p b
