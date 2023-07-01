import Control.Monad.Memo (Memo, memo, startEvalMemo)
import Data.List.Split (chunksOf)
import System.Environment (getArgs)
import Text.Tabular (Header(..), Properties(..), Table(..))
import Text.Tabular.AsciiArt (render)

type SudanArgs = (Int, Integer, Integer)

-- Given argument (n, x, y) calculate Fₙ(x, y).  For performance reasons we do
-- the calculation in a memoization monad.
sudan :: SudanArgs -> Memo SudanArgs Integer Integer
sudan (0, x, y) = return $ x + y
sudan (_, x, 0) = return x
sudan (n, x, y) = memo sudan (n, x, y-1) >>= \x2 -> sudan (n-1, x2, x2 + y)

-- A table of Fₙ(x, y) values, where the rows are y values and the columns are
-- x values.
sudanTable :: Int -> [Integer] -> [Integer] -> String
sudanTable n xs ys = render show show show
                   $ Table (Group NoLine $ map Header ys)
                           (Group NoLine $ map Header xs)
                   $ chunksOf (length xs)
                   $ startEvalMemo
                   $ sequence
                   $ [sudan (n, x, y) | y <- ys, x <- xs]

main :: IO ()
main = do
  args <- getArgs
  case args of
    [n, xlo, xhi, ylo, yhi] -> do
      putStrLn $ "Fₙ(x, y), where the rows are y values " ++
                 "and the columns are x values.\n"
      putStr $ sudanTable (read n)
                          [read xlo .. read xhi]
                          [read ylo .. read yhi]
    _ -> error "Usage: sudan n xmin xmax ymin ymax"
