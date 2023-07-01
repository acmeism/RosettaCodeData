import Data.Bool (bool)
import Data.List (replicate, transpose)
import Data.List.Split (chunksOf)

---------------------- JACOBI SYMBOL ---------------------

jacobi :: Int -> Int -> Int
jacobi = go
  where
    go 0 1 = 1
    go 0 _ = 0
    go x y
      | even r =
          plusMinus
            (rem y 8 `elem` [3, 5])
            (go (div r 2) y)
      | otherwise = plusMinus (p r && p y) (go y r)
      where
        plusMinus = bool id negate
        p = (3 ==) . flip rem 4
        r = rem x y


--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $ jacobiTable 11 9

------------------------- DISPLAY ------------------------
jacobiTable :: Int -> Int -> String
jacobiTable nCols nRows =
  let rowLabels = [1, 3 .. (2 * nRows)]
      colLabels = [0 .. pred nCols]
   in withColumnLabels ("" : fmap show colLabels) $
        labelledRows (fmap show rowLabels) $
          paddedCols $
            chunksOf nRows $
              uncurry jacobi
                <$> ((,) <$> colLabels <*> rowLabels)

------------------- TABULATION FUNCTIONS -----------------
paddedCols ::
  Show a =>
  [[a]] ->
  [[String]]
paddedCols cols =
  let scols = fmap show <$> cols
      w = maximum $ length <$> concat scols
   in map (justifyRight w ' ') <$> scols

labelledRows :: [String] -> [[String]] -> [[String]]
labelledRows labels cols =
  let w = maximum $ map length labels
   in zipWith
        (:)
        ((<> " ->") . justifyRight w ' ' <$> labels)
        (transpose cols)

withColumnLabels :: [String] -> [[String]] -> String
withColumnLabels _ [] = ""
withColumnLabels labels rows@(x : _) =
  let labelRow =
        unwords $
          zipWith
            (`justifyRight` ' ')
            (length <$> x)
            labels
   in unlines $
        labelRow :
        replicate (length labelRow) '-' : fmap unwords rows

justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c <>)
