import Data.Array
import Data.List
import Control.Monad
import System.Random

type Board = Array (Char, Char) Int

flp :: Int -> Int
flp 0 = 1
flp 1 = 0

numRows, numCols :: Board -> [Char]
numRows t = let ((a, _), (b, _)) = bounds t in [a .. b]

numCols t = let ((_, a), (_, b)) = bounds t in [a .. b]

flipRow, flipCol :: Board -> Char -> Board
flipRow t r =   let e = [ (ix, flp (t ! ix)) | ix <-
                        zip (repeat r) (numCols t) ]
                in  t // e

flipCol t c =   let e = [ (ix, flp (t ! ix)) | ix <-
                        zip (numRows t) (repeat c) ]
                in  t // e

printBoard :: Board -> IO ()
printBoard t = do
    let rows = numRows t
        cols = numCols t
        f 0 = '0'
        f 1 = '1'
        p r xs = putStrLn $ [r, ' '] ++ intersperse ' ' (map f xs)
    putStrLn $ "  " ++ intersperse ' ' cols
    zipWithM_ p rows [ [ t ! (y, x) | x <- cols ] | y <- rows ]

-- create a random goal board, and flip rows and columns randomly
-- to get a starting board
setupGame :: Char -> Char -> IO (Board, Board)
setupGame sizey sizex = do
        -- random cell value at (row, col)
    let mk rc = fmap (\v -> (rc, v)) $ randomRIO (0, 1)
        rows = ['a' .. sizey]
        cols = ['1' .. sizex]
    goal <- fmap (array (('a', '1'), (sizey, sizex))) $
                mapM mk [ (r, c) | r <- rows, c <- cols ]
    start <- do
        let change :: Board -> Int -> IO Board
            -- flip random row
            change t 0 = fmap (flipRow t) $ randomRIO ('a', sizey)
            -- flip random col
            change t 1 = fmap (flipCol t) $ randomRIO ('1', sizex)
        numMoves <- randomRIO (3, 15) -- how many flips (3 - 15)
        -- determine if rows or cols are flipped
        moves <- replicateM numMoves $ randomRIO (0, 1)
        -- make changes and get a starting board
        foldM change goal moves
    if goal /= start -- check if boards are different
        then return (goal, start) -- all ok, return both boards
        else setupGame sizey sizex -- try again

main :: IO ()
main = do
    putStrLn "Select a board size (1 - 9).\nPress any other key to exit."
    sizec <- getChar
    when (sizec `elem` ['1' .. '9']) $ do
        let size = read [sizec] - 1
        (g, s) <- setupGame (['a'..] !! size) (['1'..] !! size)
        turns g s 0

    where
        turns goal current moves = do
            putStrLn "\nGoal:"
            printBoard goal
            putStrLn "\nBoard:"
            printBoard current
            when (moves > 0) $
                putStrLn $ "\nYou've made " ++ show moves ++ " moves so far."
            putStrLn $ "\nFlip a row (" ++ numRows current ++
                ") or a column (" ++ numCols current ++ ")"
            v <- getChar
            if v `elem` numRows current
                then check $ flipRow current v
                else if v `elem` numCols current
                    then check $ flipCol current v
                    else tryAgain

            where   check t =   if t == goal
                                    then putStrLn $ "\nYou've won in " ++
                                            show (moves + 1) ++ " moves!"
                                    else turns goal t (moves + 1)

                    tryAgain = do
                        putStrLn ": Invalid row or column."
                        turns goal current moves
