import Control.Monad (replicateM, unless)
import Data.List (tails, transpose)
import System.Random (randomRIO)

data Cell
  = Empty
  | Tree
  | Fire
  deriving (Eq)

instance Show Cell where
  show Empty = " "
  show Tree = "T"
  show Fire = "$"

randomCell :: IO Cell
randomCell = fmap ([Empty, Tree] !!) (randomRIO (0, 1) :: IO Int)

randomChance :: IO Double
randomChance = randomRIO (0, 1.0) :: IO Double

rim :: a -> [[a]] -> [[a]]
rim b = fmap (fb b) . (fb =<< rb)
  where
    fb = (.) <$> (:) <*> (flip (++) . return)
    rb = fst . unzip . zip (repeat b) . head

take3x3 :: [[a]] -> [[[a]]]
take3x3 = concatMap (transpose . fmap take3) . take3
  where
    take3 = init . init . takeWhile (not . null) . fmap (take 3) . tails

list2Mat :: Int -> [a] -> [[a]]
list2Mat n = takeWhile (not . null) . fmap (take n) . iterate (drop n)

evolveForest :: Int -> Int -> Int -> IO ()
evolveForest m n k = do
  let s = m * n
  fs <- replicateM s randomCell
  let nextState xs = do
        ts <- replicateM s randomChance
        vs <- replicateM s randomChance
        let rv [r1, [l, c, r], r3] newTree fire
              | c == Fire = Empty
              | c == Tree && Fire `elem` concat [r1, [l, r], r3] = Fire
              | c == Tree && 0.01 >= fire = Fire
              | c == Empty && 0.1 >= newTree = Tree
              | otherwise = c
        return $ zipWith3 rv xs ts vs
      evolve i xs =
        unless (i > k) $
        do let nfs = nextState $ take3x3 $ rim Empty $ list2Mat n xs
           putStrLn ("\n>>>>>> " ++ show i ++ ":")
           mapM_ (putStrLn . concatMap show) $ list2Mat n xs
           nfs >>= evolve (i + 1)
  evolve 1 fs

main :: IO ()
main = evolveForest 6 50 3
