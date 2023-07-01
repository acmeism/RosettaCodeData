import System.Random
import Data.List (sortBy, genericLength, minimumBy)
import Data.Ord (comparing)

-- A finite list of dimensional accessors tell a KDTree how to get a
-- Euclidean dimensional value 'b' out of an arbitrary datum 'a'.
type DimensionalAccessors a b = [a -> b]

-- A binary tree structure of 'a'.
data Tree a = Node a (Tree a) (Tree a)
            | Empty

instance Show a => Show (Tree a) where
  show Empty = "Empty"
  show (Node value left right) =
    "(" ++ show value ++ " " ++ show left ++ " " ++ show right ++ ")"

-- A k-d tree structure of 'a' with Euclidean dimensions of 'b'.
data KDTree a b = KDTree (DimensionalAccessors a b) (Tree a)

instance Show a => Show (KDTree a b) where
  show (KDTree _ tree) = "KDTree " ++ show tree

-- The squared Euclidean distance formula.
sqrDist :: Num b => DimensionalAccessors a b -> a -> a -> b
sqrDist dims a b = sum $ map square $ zipWith (-) a' b'
  where
    a' = map ($ a) dims
    b' = map ($ b) dims

square :: Num a => a -> a
square = (^ 2)

-- Insert a value into a k-d tree.
insert :: Ord b => KDTree a b -> a -> KDTree a b
insert (KDTree dims tree) value = KDTree dims $ ins (cycle dims) tree
  where
    ins _      Empty                   = Node value Empty Empty
    ins (d:ds) (Node split left right) =
      if d value < d split
      then Node split (ins ds left) right
      else Node split left (ins ds right)

-- Produce an empty k-d tree.
empty :: DimensionalAccessors a b -> KDTree a b
empty dims = KDTree dims Empty

-- Produce a k-d tree with one value.
singleton :: Ord b => DimensionalAccessors a b -> a -> KDTree a b
singleton dims value = insert (empty dims) value

-- Create a k-d tree from a list of values using the median-finding algorithm.
fromList :: Ord b => DimensionalAccessors a b -> [a] -> KDTree a b
fromList dims values = KDTree dims $ fList (cycle dims) values
  where
    fList _      []     = Empty
    fList (d:ds) values =
      let sorted          = sortBy (comparing d) values
          (lower, higher) = splitAt (genericLength sorted `div` 2) sorted
      in case higher of
        []          -> Empty
        median:rest -> Node median (fList ds lower) (fList ds rest)

-- Create a k-d tree from a list of values by repeatedly inserting the values
-- into a tree. Faster than median-finding, but can create unbalanced trees.
fromListLinear :: Ord b => DimensionalAccessors a b -> [a] -> KDTree a b
fromListLinear dims values = foldl insert (empty dims) values

-- Given a k-d tree, find the nearest value to a given value.
-- Also report how many nodes were visited.
nearest :: (Ord b, Num b, Integral c) => KDTree a b -> a -> (Maybe a, c)
nearest (KDTree dims tree) value = near (cycle dims) tree
  where
    dist = sqrDist dims
    -- If we have an empty tree, then return nothing.
    near _      Empty                    = (Nothing, 1)
    -- We hit a leaf node, so it is the current best.
    near _      (Node split Empty Empty) = (Just split, 1)
    near (d:ds) (Node split left right)  =
      -- Move down the tree in the fashion of insertion.
      let dimdist x y    = square (d x - d y)
          splitDist      = dist value split
          hyperPlaneDist = dimdist value split
          bestLeft       = near ds left
          bestRight      = near ds right
          -- maybeThisBest is the node of the side of the split where the value
          -- resides, and maybeOtherBest is the node on the other side of the split.
          ((maybeThisBest, thisCount), (maybeOtherBest, otherCount)) =
            if d value < d split
            then (bestLeft, bestRight)
            else (bestRight, bestLeft)
      in case maybeThisBest of
        Nothing    ->
          -- From the search point (in this case), the hypersphere radius to
          -- the split node is always >= the hyperplane distance, so we will
          -- always check the other side.
          let count = 1 + thisCount + otherCount
          in case maybeOtherBest of
            -- We are currently at a leaf node, so this is the only choice.
            -- It is not strictly necessary to take care of this case
            -- because of the above pattern matching in near.
            Nothing         -> (Just split, count)
            -- We have a node on the other side, so compare
            -- it to the split point to see which is closer.
            Just otherBest ->
              if dist value otherBest < splitDist
              then (maybeOtherBest, count)
              else (Just split, count)

        Just thisBest ->
          let thisBestDist = dist value thisBest
              best         =
                -- Determine which is the closer node of this side.
                if splitDist < thisBestDist
                then split
                else thisBest
              bestDist     = dist value best
          in
            if bestDist < hyperPlaneDist
            -- If the distance to the best node is less than the distance
            -- to the splitting hyperplane, then the current best node is the
            -- only choice.
            then (Just best, 1 + thisCount)
            -- There is a chance that a node on the other side is closer
            -- than the current best.
            else
              let count = 1 + thisCount + otherCount
              in case maybeOtherBest of
                Nothing        -> (Just best, count)
                Just otherBest ->
                  if bestDist < dist value otherBest
                  then (Just best, count)
                  else (maybeOtherBest, count)

-- Dimensional accessors for a 2-tuple
tuple2D :: [(a, a) -> a]
tuple2D = [fst, snd]

-- Dimensional accessors for a 3-tuple
tuple3D :: [(a, a, a) -> a]
tuple3D = [d1, d2, d3]
  where
    d1 (a, _, _) = a
    d2 (_, b, _) = b
    d3 (_, _, c) = c

-- Random 3-tuple generation
instance (Random a, Random b, Random c) => Random (a, b, c) where
  random gen =
    let (vA, genA) = random gen
        (vB, genB) = random genA
        (vC, genC) = random genB
    in ((vA, vB, vC), genC)

  randomR ((lA, lB, lC), (hA, hB, hC)) gen =
    let (vA, genA) = randomR (lA, hA) gen
        (vB, genB) = randomR (lB, hB) genA
        (vC, genC) = randomR (lC, hC) genB
    in ((vA, vB, vC), genC)

printResults :: (Show a, Show b, Show c, Floating c) =>
                a -> (Maybe a, b) -> DimensionalAccessors a c -> IO ()
printResults point result dims = do
  let (nearest, visited) = result
  case nearest of
    Nothing    -> putStrLn "Could not find nearest."
    Just value -> do
      let dist = sqrt $ sqrDist dims point value
      putStrLn $ "Point:    " ++ show point
      putStrLn $ "Nearest:  " ++ show value
      putStrLn $ "Distance: " ++ show dist
      putStrLn $ "Visited:  " ++ show visited
      putStrLn ""

-- Naive nearest search used to confirm results.
linearNearest :: (Ord b, Num b) => DimensionalAccessors a b -> a -> [a] -> Maybe a
linearNearest _    _     [] = Nothing
linearNearest dims value xs = Just $ minimumBy (comparing $ sqrDist dims value) xs

main :: IO ()
main = do
  let wikiValues :: [(Double, Double)]
      wikiValues  = [(2, 3), (5, 4), (9, 6), (4, 7), (8, 1), (7, 2)]
      wikiTree    = fromList tuple2D wikiValues
      wikiSearch  = (9, 2)
      wikiNearest = nearest wikiTree wikiSearch
  putStrLn "Wikipedia example:"
  printResults wikiSearch wikiNearest tuple2D

  let stdGen                = mkStdGen 0
      randRange :: ((Double, Double, Double), (Double, Double, Double))
      randRange             = ((0, 0, 0), (1000, 1000, 1000))
      (randSearch, stdGenB) = randomR randRange stdGen
      randValues            = take 1000 $ randomRs randRange stdGenB
      randTree              = fromList tuple3D randValues
      randNearest           = nearest randTree randSearch
      randNearestLinear     = linearNearest tuple3D randSearch randValues
  putStrLn "1000 random 3D points on the range of [0, 1000):"
  printResults randSearch randNearest tuple3D
  putStrLn "Confirm naive nearest:"
  print randNearestLinear
