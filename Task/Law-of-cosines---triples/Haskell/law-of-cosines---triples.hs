import qualified Data.Map.Strict as Map
import qualified Data.Set as Set
import Data.Monoid ((<>))

triangles
  :: (Map.Map Int Int -> Int -> Int -> Int -> Int -> Maybe Int)
  -> Int
  -> [(Int, Int, Int)]
triangles f n =
  let mapRoots = Map.fromList $ ((,) =<< (^ 2)) <$> [1 .. n]
  in Set.elems $
     foldr
       (\(suma2b2, a, b) triSet ->
           (case f mapRoots suma2b2 (a * b) a b of
              Just c -> Set.insert (a, b, c) triSet
              _ -> triSet))
       (Set.fromList [])
       ([1 .. n] >>=
        (\a -> (flip (,,) a =<< (a * a +) . (>>= id) (*)) <$> [1 .. a]))


-- TESTS ------------------------------------------------------------------------

f90, f60, f60ne, f120 :: Map.Map Int Int -> Int -> Int -> Int -> Int -> Maybe Int
f90 dct x2 ab a b = Map.lookup x2 dct

f60 dct x2 ab a b = Map.lookup (x2 - ab) dct

f120 dct x2 ab a b = Map.lookup (x2 + ab) dct

f60ne dct x2 ab a b
  | a == b = Nothing
  | otherwise = Map.lookup (x2 - ab) dct

main :: IO ()
main = do
  putStrLn
    (unlines $
     "Triangles of maximum side 13\n" :
     zipWith
       (\f n ->
           let solns = triangles f 13
           in show (length solns) <> " solutions for " <> show n <>
              " degrees:\n" <>
              unlines (show <$> solns))
       [f120, f90, f60]
       [120, 90, 60])
  putStrLn "60 degrees - uneven triangles of maximum side 10000. Total:"
  print $ length $ triangles f60ne 10000
