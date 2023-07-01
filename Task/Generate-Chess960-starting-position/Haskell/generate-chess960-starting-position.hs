import Data.List
import qualified Data.Set as Set

data Piece = K | Q | R | B | N deriving (Eq, Ord, Show)

isChess960 :: [Piece] -> Bool
isChess960 rank =
  (odd . sum $ findIndices (== B) rank) && king > rookA && king < rookB
  where
    Just king      = findIndex (== K) rank
    [rookA, rookB] = findIndices (== R) rank

main :: IO ()
main = mapM_ (putStrLn . concatMap show) . Set.toList . Set.fromList
       . filter isChess960 $ permutations [R,N,B,Q,K,B,N,R]
