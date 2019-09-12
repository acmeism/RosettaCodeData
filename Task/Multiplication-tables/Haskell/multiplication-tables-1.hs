import Data.Maybe (fromMaybe, maybe)
import Data.Bool (bool)

table :: [Int] -> [[Maybe Int]]
table xs =
  let axis = Just <$> xs
  in (Nothing : axis) :
     zipWith
       (:)
       axis
       [ [ bool (Just (x * y)) Nothing (x > y)
         | y <- xs ]
       | x <- xs ]

-- TEST ---------------------------------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
  (showTable . table) <$> [[13 .. 20], [1 .. 12], [95 .. 100]]

-- FORMATTING ---------------------------------------------
showTable :: [[Maybe Int]] -> String
showTable xs =
  let w = 1 + (length . show) (fromMaybe 0 $ (last . last) xs)
      gap = replicate w ' '
      rows = (maybe gap (rjust w ' ' . show) =<<) <$> xs
  in unlines $ head rows : [] : tail rows

rjust :: Int -> Char -> String -> String
rjust n c = (drop . length) <*> (replicate n c ++)
