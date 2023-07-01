module Main where

import Control.Monad.State (evalState)
import RandomChess (ChessBoard, emptyBoard, placeKings, getBoard,
                    placePawns, placeRemaining, toFen, BoardState (..))
import System.Random (newStdGen)

draw :: ChessBoard -> IO ()
draw b = do
  showXAxis >> drawLine
  mapM_ (\b@(p, (x,y)) ->
          case x of 'h' -> putStr (" | " <> show p <> " | " <> show y <> "\n") >> drawLine
                    'a' -> putStr (show y <> " | " <> show p)
                    _   -> putStr (" | " <> show p)
        )
    b
  showXAxis >> putStrLn "" >> putStrLn (toFen b)

 where
  drawLine = putStrLn ("  " <> replicate 33 '-')
  showXAxis = do
    putStr " "
    mapM_ (\(_, (x, _)) -> putStr $ "   " <> [x]) (take 8 b)
    putStrLn ""

main :: IO ()
main = BoardState emptyBoard <$> newStdGen >>= draw . evalState buildBoard
  where
    buildBoard = placeKings >> placePawns >> placeRemaining >> getBoard
