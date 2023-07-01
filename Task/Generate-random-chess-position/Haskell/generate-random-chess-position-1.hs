{-# LANGUAGE LambdaCase, TupleSections #-}

module RandomChess
( placeKings
, placePawns
, placeRemaining
, emptyBoard
, toFen
, ChessBoard
, Square (..)
, BoardState (..)
, getBoard
)
where

import Control.Monad.State (State, get, gets, put)
import Data.List (find, sortBy)
import System.Random (Random, RandomGen, StdGen, random, randomR)

type Pos = (Char, Int)

type ChessBoard = [(Square, Pos)]

data PieceRank  = King | Queen | Rook | Bishop | Knight | Pawn
  deriving (Enum, Bounded, Show, Eq, Ord)
data PieceColor = Black | White
  deriving (Enum, Bounded, Show, Eq, Ord)

data Square = ChessPiece PieceRank PieceColor | EmptySquare
  deriving (Eq, Ord)

type PieceCount = [(Square, Int)]

data BoardState = BoardState { board :: ChessBoard , generator :: StdGen }

instance Show Square where
  show (ChessPiece King   Black) = "♚"
  show (ChessPiece Queen  Black) = "♛"
  show (ChessPiece Rook   Black) = "♜"
  show (ChessPiece Bishop Black) = "♝"
  show (ChessPiece Knight Black) = "♞"
  show (ChessPiece Pawn   Black) = "♟"
  show (ChessPiece King   White) = "♔"
  show (ChessPiece Queen  White) = "♕"
  show (ChessPiece Rook   White) = "♖"
  show (ChessPiece Bishop White) = "♗"
  show (ChessPiece Knight White) = "♘"
  show (ChessPiece Pawn   White) = "♙"
  show EmptySquare               = " "

instance Random PieceRank where
  randomR (a, b) g = case randomR (fromEnum a, fromEnum b) g of
    (x, g'') -> (toEnum x, g'')
  random = randomR (minBound, maxBound)

instance Random PieceColor where
  randomR (a, b) g = case randomR (fromEnum a, fromEnum b) g of
    (x, g'') -> (toEnum x, g'')
  random = randomR (minBound, maxBound)

fullBoard :: PieceCount
fullBoard =
  [ (ChessPiece King Black  , 1)
  , (ChessPiece Queen Black , 1)
  , (ChessPiece Rook Black  , 2)
  , (ChessPiece Bishop Black, 2)
  , (ChessPiece Knight Black, 2)
  , (ChessPiece Pawn Black  , 8)
  , (ChessPiece King White  , 1)
  , (ChessPiece Queen White , 1)
  , (ChessPiece Rook White  , 2)
  , (ChessPiece Bishop White, 2)
  , (ChessPiece Knight White, 2)
  , (ChessPiece Pawn White  , 8)
  , (EmptySquare            , 32)
  ]

emptyBoard :: ChessBoard
emptyBoard = fmap (EmptySquare,) . (,) <$> ['a'..'h'] <*> [1..8]

replaceSquareByPos :: (Square, Pos) -> ChessBoard -> ChessBoard
replaceSquareByPos e@(_, p) = fmap (\x -> if p == snd x then e else x)

isPosOccupied :: Pos -> ChessBoard -> Bool
isPosOccupied p = occupied . find (\x -> p == snd x)
 where
  occupied (Just (EmptySquare, _)) = False
  occupied _                       = True

isAdjacent :: Pos -> Pos -> Bool
isAdjacent (x1, y1) (x2, y2) =
  let upOrDown    = (pred y1 == y2 || succ y1 == y2)
      leftOrRight = (pred x1 == x2 || succ x1 == x2)
  in  (x2 == x1 && upOrDown)
        || (pred x1 == x2 && upOrDown)
        || (succ x1 == x2 && upOrDown)
        || (leftOrRight && y1 == y2)

fen :: Square -> String
fen (ChessPiece King   Black) = "k"
fen (ChessPiece Queen  Black) = "q"
fen (ChessPiece Rook   Black) = "r"
fen (ChessPiece Bishop Black) = "b"
fen (ChessPiece Knight Black) = "n"
fen (ChessPiece Pawn   Black) = "p"
fen (ChessPiece King   White) = "K"
fen (ChessPiece Queen  White) = "Q"
fen (ChessPiece Rook   White) = "R"
fen (ChessPiece Bishop White) = "B"
fen (ChessPiece Knight White) = "N"
fen (ChessPiece Pawn   White) = "P"

boardSort :: (Square, Pos) -> (Square, Pos) -> Ordering
boardSort (_, (x1, y1)) (_, (x2, y2)) | y1 < y2  = GT
                                      | y1 > y2  = LT
                                      | y1 == y2 = compare x1 x2

toFen :: ChessBoard -> String
toFen [] = " w - - 0 1" <> []
toFen b = scanRow (fst <$> take 8 b) 0
  where
    scanRow [] 0               = nextRow
    scanRow [] n               = show n <> nextRow
    scanRow (EmptySquare:xs) n = scanRow xs (succ n)
    scanRow (x:xs) 0           = nextPiece x xs
    scanRow (x:xs) n           = show n <> nextPiece x xs
    nextRow = "/" <> toFen (drop 8 b)
    nextPiece x xs = fen x <> scanRow xs 0

-- State functions
withStateGen :: (StdGen -> (a, StdGen)) -> State BoardState a
withStateGen f = do
  currentState <- get
  let gen1 = generator currentState
  let (x, gen2) = f gen1
  put (currentState {generator = gen2})
  pure x

randomPos :: State BoardState Pos
randomPos = do
  boardState <- gets board
  chr <- withStateGen (randomR ('a', 'h'))
  num <- withStateGen (randomR (1, 8))
  let pos = (chr, num)
  if isPosOccupied pos boardState then
    randomPos
  else
    pure pos

randomPiece :: State BoardState Square
randomPiece = ChessPiece <$> withStateGen random <*> withStateGen random

placeKings :: State BoardState ()
placeKings = do
  currentState <- get
  p1 <- randomPos
  p2 <- randomPos
  if p1 `isAdjacent` p2 || p1 == p2
    then placeKings
    else do
      let updatedBoard = replaceSquareByPos (ChessPiece King White, p1) $
            replaceSquareByPos (ChessPiece King Black, p2) (board currentState)
      put currentState { board = updatedBoard }

placePawns :: State BoardState ()
placePawns = withStateGen (randomR (1, 16)) >>= go
  where
    go :: Int -> State BoardState ()
    go 0 = pure ()
    go n = do
      currentState <- get
      pos <- randomPos
      color <- withStateGen random
      let pawn = ChessPiece Pawn color
      let currentBoard = board currentState
      if promoted color == snd pos || isPosOccupied pos currentBoard ||
                           enpassant color == snd pos || firstPos color == snd pos
        then go n
        else do
          put currentState { board = replaceSquareByPos (pawn, pos) currentBoard }
          go $ pred n
    promoted White = 8
    promoted Black = 1
    enpassant White = 5
    enpassant Black = 4
    firstPos White = 1
    firstPos Black = 8

placeRemaining :: State BoardState ()
placeRemaining =
  withStateGen (randomR (5, sum $ fmap snd remaining)) >>= go remaining
  where
    remaining = filter (\case
                         (ChessPiece King _, _) -> False
                         (ChessPiece Pawn _, _) -> False
                         (EmptySquare, _) -> False
                         _ -> True)
                        fullBoard

    go :: PieceCount -> Int -> State BoardState ()
    go _ 0 = pure ()
    go remaining n = do
      currentState <- get
      let currentBoard = board currentState
      position <- randomPos
      piece <- randomPiece
      if not (isPermitted piece) || isPosOccupied position currentBoard
        then go remaining n
        else do
          let updatedBoard = replaceSquareByPos (piece, position) currentBoard
          put currentState { board = updatedBoard }
          go (consume piece remaining) (pred n)
      where
        isPermitted p =
          case find ((==p) . fst) remaining of
            Just (_, count) -> count > 0
            Nothing         -> False
        consume p'' = fmap (\(p, c) -> if p == p'' then (p, pred c) else (p, c))

getBoard :: State BoardState ChessBoard
getBoard = gets (sortBy boardSort . board)
