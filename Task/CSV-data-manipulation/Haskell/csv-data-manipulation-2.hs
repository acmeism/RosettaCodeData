{-# LANGUAGE FlexibleContexts,
             TypeFamilies,
             NoMonomorphismRestriction #-}
import Data.List (intercalate)
import Data.List.Split (splitOn)
import Lens.Micro

(<$$>) :: (Functor f1, Functor f2) =>
          (a -> b) -> f1 (f2 a) -> f1 (f2 b)
(<$$>) = fmap . fmap

------------------------------------------------------------
-- reading and writing

newtype CSV = CSV { values :: [[String]] }

readCSV :: String -> CSV
readCSV = CSV . (splitOn "," <$$> lines)

instance Show CSV where
  show = unlines . map (intercalate ",") . values

------------------------------------------------------------
-- construction and combination

mkColumn, mkRow :: [String] -> CSV
(<||>), (<==>) :: CSV -> CSV -> CSV

mkColumn lst = CSV $ sequence [lst]
mkRow lst    = CSV [lst]

CSV t1 <||> CSV t2 = CSV $ zipWith (++) t1 t2
CSV t1 <==> CSV t2 = CSV $ t1 ++ t2

------------------------------------------------------------
-- access and modification via lenses

table = lens values (\csv t -> csv {values = t})
row i = table . ix i . traverse
col i = table . traverse . ix i
item i j = table . ix i . ix j

------------------------------------------------------------

sample = readCSV "C1, C2, C3, C4, C5\n\
                 \1,  5,  9,  13, 17\n\
                 \2,  6,  10, 14, 18\n\
                 \3,  7,  11, 15, 19\n\
                 \4,  8,  12, 16, 20"
