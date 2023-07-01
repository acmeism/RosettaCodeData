import           Control.Applicative          ((<|>))
import           Control.Monad
import           Control.Monad.CSP
import           Data.List                    (transpose)
import           System.Environment           (getArgs)
import           Text.ParserCombinators.ReadP (ReadP)
import qualified Text.ParserCombinators.ReadP as P
import           Text.Printf                  (printf)

main :: IO ()
main = do
    file <- parseArgs
    printf "reading problem file from %s\n" file
    ps <- parseProblems file
    forM_ ps $ \p -> do
        print p
        putStrLn ""
        printSolution $ solve p
        putStrLn ""

-------------------------------------------------------------------------------
-- parsing
-------------------------------------------------------------------------------

parseArgs :: IO FilePath
parseArgs = do
    args <- getArgs
    case args of
        [file] -> return file
        _      -> ioError $ userError "expected exactly one command line argument, the name of the problem file"

data Problem = Problem
    { rows :: [[Int]]
    , cols :: [[Int]]
    } deriving (Show, Read, Eq, Ord)

entryP :: ReadP Int
entryP = do
    n <- fromEnum <$> P.get
    if n < 65 || n > 90
        then P.pfail
        else return $ n - 64

blankP, eolP :: ReadP Char
blankP = P.char ' '
eolP   = P.char '\n'

entriesP :: ReadP [Int]
entriesP = ([] <$ blankP) <|> P.many1 entryP

lineP :: ReadP [[Int]]
lineP = P.sepBy1 entriesP blankP <* eolP

problemP :: ReadP Problem
problemP = Problem <$> lineP <*> lineP

problemsP :: ReadP [Problem]
problemsP = P.sepBy1 problemP (P.many blankP <* eolP) <* P.eof

parseProblems :: FilePath -> IO [Problem]
parseProblems file = do
    s <- readFile file
    case P.readP_to_S problemsP s of
        [(ps, "")] -> return ps
        _          -> ioError $ userError $ "error parsing file " <> file

-------------------------------------------------------------------------------
-- CSP
-------------------------------------------------------------------------------

solve :: Problem -> [[Bool]]
solve = oneCSPSolution . problemCSP

problemCSP :: Problem -> CSP r [[DV r Bool]]
problemCSP p = do
    let rowCount = length $ rows p
        colCount = length $ cols p
    cells <- replicateM rowCount
           $ replicateM colCount
           $ mkDV [False, True]

    forM_ (zip cells             $ rows p) $ uncurry rowOrColCSP
    forM_ (zip (transpose cells) $ cols p) $ uncurry rowOrColCSP

    return cells

rowOrColCSP :: [DV r Bool] -> [Int] -> CSP r ()
rowOrColCSP ws [] = forM_ ws $ constraint1 not
rowOrColCSP ws xs = do
    let vs = zip [0 ..] ws
        n  = length ws

    blocks <- forM xs $ \x ->
        mkDV [(i, i + x - 1) | i <- [0 .. n - x]] -- the blocks, given by first and last index

    -- blocks must be separate and not overlapping
    f blocks

    -- cells in blocks are set
    forM_ blocks $ \x ->
        forM_ vs $ \(i, y) ->
            constraint2 (\(x1, x2) b -> i < x1 || i > x2 || b) x y

    -- cells before the first block are not set
    forM_ vs $ \(i, y) ->
        constraint2 (\(y', _) b -> i >= y' || not b) (head blocks) y

    -- cells after the last block are not set
    forM_ vs $ \(i, y) ->
        constraint2 (\(_, y') b -> i <= y' || not b) (last blocks) y

    -- cells between blocks are not set
    forM_ (zip blocks $ tail blocks) $ \(x, y) ->
        forM_ vs $ \(i, z) ->
            constraint3 (\(_, x') (y', _) b -> i <= x' || i >= y' || not b) x y z
  where
    f :: [DV r (Int, Int)] -> CSP r ()
    f (u : v : bs) = do
        constraint2 (\(_, u') (v', _) -> v' >= u' + 2)  u v
        f $ v : bs
    f _            = return ()

-------------------------------------------------------------------------------
-- printing
-------------------------------------------------------------------------------

printSolution :: [[Bool]] -> IO ()
printSolution bss =
    forM_ bss $ \bs -> do
        forM_ bs $ \b ->
            putChar $ if b then '#' else '.'
        putChar '\n'
