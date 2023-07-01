{-# LANGUAGE TemplateHaskell #-}

module MineSweeper
  ( Board
  , Cell(..)
  , CellState(..)
  , Pos
    -- lenses / prisms
  , pos
  , coveredLens
  , coveredFlaggedLens
  , coveredMinedLens
  , xCoordLens
  , yCoordLens
    -- Functions
  , emptyBoard
  , groupedByRows
  , displayCell
  , isLoss
  , isWin
  , exposeMines
  , openCell
  , flagCell
  , mineBoard
  , totalRows
  , totalCols )
where

import Control.Lens  ((%~), (&), (.~), (^.), (^?), Lens', Traversal', _1, _2,
                      anyOf, filtered, folded, lengthOf, makeLenses, makePrisms,
                      preview, to, view)
import Data.List     (find, groupBy, nub, delete, sortBy)
import Data.Maybe    (isJust)
import System.Random (getStdGen, getStdRandom, randomR, randomRs)

type Pos = (Int, Int)
type Board = [Cell]

data CellState = Covered   { _mined :: Bool, _flagged :: Bool }
               | UnCovered { _mined :: Bool }
               deriving (Show, Eq)

data Cell = Cell
          { _pos :: Pos
          , _state :: CellState
          , _cellId :: Int
          , _adjacentMines :: Int }
          deriving (Show, Eq)

makePrisms ''CellState
makeLenses ''CellState
makeLenses ''Cell

-- Re-useable lens.
coveredLens :: Traversal' Cell (Bool, Bool) --'
coveredLens = state . _Covered

coveredMinedLens, coveredFlaggedLens, unCoveredLens :: Traversal' Cell Bool --'
coveredMinedLens = coveredLens . _1
coveredFlaggedLens = coveredLens . _2
unCoveredLens = state . _UnCovered

xCoordLens, yCoordLens :: Lens' Cell Int --'
xCoordLens = pos . _1
yCoordLens = pos . _2

-- Adjust row and column size to your preference.
totalRows, totalCols :: Int
totalRows = 4
totalCols = 6

emptyBoard :: Board
emptyBoard = (\(n, p) -> Cell { _pos = p
                              , _state = Covered False False
                              , _adjacentMines = 0
                              , _cellId = n }) <$> zip [1..] positions
  where
    positions = (,) <$> [1..totalCols] <*> [1..totalRows]

updateCell :: Cell -> Board -> Board
updateCell cell = fmap (\c -> if cell ^. cellId == c ^. cellId then cell else c)

updateBoard :: Board -> [Cell] -> Board
updateBoard = foldr updateCell

okToOpen :: [Cell] -> [Cell]
okToOpen = filter (\c -> c ^? coveredLens == Just (False, False))

openUnMined :: Cell -> Cell
openUnMined = state .~ UnCovered False

openCell :: Pos -> Board -> Board
openCell p b = f $ find (\c -> c ^. pos == p) b
 where
  f (Just c)
    | c ^? coveredFlaggedLens == Just True = b
    | c ^? coveredMinedLens == Just True = updateCell
      (c & state .~ UnCovered True)
      b
    | isCovered c = if c ^. adjacentMines == 0 && not (isFirstMove b)
      then updateCell (openUnMined c) $ expandEmptyCells b c
      else updateCell (openUnMined c) b
    | otherwise = b
  f Nothing = b
  isCovered = isJust . preview coveredLens

expandEmptyCells :: Board -> Cell -> Board
expandEmptyCells board cell
  | null openedCells = board
  | otherwise = foldr (flip expandEmptyCells) updatedBoard (zeroAdjacent openedCells)
 where
  findMore _ [] = []
  findMore exclude (c : xs)
    | c `elem` exclude        = findMore exclude xs
    | c ^. adjacentMines == 0 = c : adjacent c <>
      findMore (c : exclude <> adjacent c) xs
    | otherwise               = c : findMore (c : exclude) xs
  adjacent     = okToOpen . flip adjacentCells board
  openedCells  = openUnMined <$> nub (findMore [cell] (adjacent cell))
  zeroAdjacent = filter (view (adjacentMines . to (== 0)))
  updatedBoard = updateBoard board openedCells

flagCell :: Pos -> Board -> Board
flagCell p board = case find ((== p) . view pos) board of
  Just c  -> updateCell (c & state . flagged %~ not) board
  Nothing -> board

adjacentCells :: Cell -> Board -> [Cell]
adjacentCells Cell {_pos = c@(x1, y1)} = filter (\c -> c ^. pos `elem` positions)
  where
    f n = [pred n, n, succ n]
    positions = delete c $ [(x, y) | x <- f x1, x > 0, y <- f y1, y > 0]

isLoss, isWin, allUnMinedOpen, allMinesFlagged, isFirstMove :: Board -> Bool
isLoss = anyOf (traverse . unCoveredLens) (== True)
isWin b = allUnMinedOpen b || allMinesFlagged b

allUnMinedOpen = (== 0) . lengthOf (traverse . coveredMinedLens . filtered (== False))
allMinesFlagged b = minedCount b == flaggedMineCount b
 where
  minedCount = lengthOf (traverse . coveredMinedLens . filtered (== True))
  flaggedMineCount = lengthOf (traverse . coveredLens . filtered (== (True, True)))

isFirstMove = (== totalCols * totalRows) . lengthOf (folded . coveredFlaggedLens . filtered (== False))

groupedByRows :: Board -> [Board]
groupedByRows = groupBy (\c1 c2 -> yAxis c1 == yAxis c2)
              . sortBy (\c1 c2 -> yAxis c1 `compare` yAxis c2)
  where
    yAxis = view yCoordLens

displayCell :: Cell -> String
displayCell c
  | c ^? unCoveredLens            == Just True = "X"
  | c ^? coveredFlaggedLens       == Just True = "?"
  | c ^? (unCoveredLens . to not) == Just True =
    if c ^. adjacentMines > 0 then show $ c ^. adjacentMines else "▢"
  | otherwise = "."

exposeMines :: Board -> Board
exposeMines = fmap (\c -> c & state . filtered (\s -> s ^? _Covered . _1 == Just True) .~ UnCovered True)

updateMineCount :: Board -> Board
updateMineCount b = go b
 where
  go []       = []
  go (x : xs) = (x & adjacentMines .~ totalAdjacentMines b) : go xs
   where
    totalAdjacentMines =
      foldr (\c acc -> if c ^. (state . mined) then succ acc else acc) 0 . adjacentCells x

-- IO
mineBoard :: Pos -> Board -> IO Board
mineBoard p board = do
  totalMines <- randomMinedCount
  minedBoard totalMines >>= \mb -> pure $ updateMineCount mb
 where
  mines n = take n <$> randomCellIds
  minedBoard n = (\m ->
    fmap (\c -> if c ^. cellId `elem` m then c & state . mined .~ True else c)
        board) . filter (\c -> openedCell ^. cellId /= c)
      <$> mines n
  openedCell = head $ filter (\c -> c ^. pos == p) board

randomCellIds :: IO [Int]
randomCellIds = randomRs (1, totalCols * totalRows) <$> getStdGen

randomMinedCount :: IO Int
randomMinedCount = getStdRandom $ randomR (minMinedCells, maxMinedCells)
 where
  maxMinedCells = floor $ realToFrac (totalCols * totalRows) * 0.2
  minMinedCells = floor $ realToFrac (totalCols * totalRows) * 0.1
