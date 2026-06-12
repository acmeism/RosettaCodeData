import Control.Applicative (liftA2)
import Data.List (genericLength, intersect, nub, union)
import Data.List.Split (chunksOf)
import Data.Ratio (denominator, numerator)
import Text.Tabular (Header(..), Properties(..), Table(..))
import Text.Tabular.AsciiArt (render)

-- The Jaccard index of two sets.  If both sets are empty we define the index to
-- be 1.
jaccard :: (Eq a, Fractional b) => [a] -> [a] -> b
jaccard [] [] = 1
jaccard xs ys = let uxs = nub xs -- unique xs
                    isz = genericLength $ intersect uxs ys
                    usz = genericLength $ union     uxs ys
                in isz / usz

-- A table of Jaccard indexes for all pairs of sets given in the argument.
-- Associated with each set is its "name", which is only used for display
-- purposes.
jaccardTable :: Eq a => [(String, [a])] -> String
jaccardTable xs = render id id showRat
                $ Table (Group SingleLine $ map Header names)
                        (Group SingleLine $ map Header names)
                $ chunksOf (length xs)
                $ map (uncurry jaccard)
                $ allPairs sets
  where names = map fst xs
        sets  = map snd xs

-- Show a rational number as numerator/denominator.  If the denominator is 1
-- then just show the numerator.
showRat :: Rational -> String
showRat r = case (numerator r, denominator r) of
              (n, 1) -> show n
              (n, d) -> show n ++ "/" ++ show d

-- All pairs of elements from the list.  For example:
--
--   allPairs [1,2] == [(1,1),(1,2),(2,1),(2,2)]
allPairs :: [a] -> [(a,a)]
allPairs xs = liftA2 (,) xs xs

main :: IO ()
main = putStrLn $ jaccardTable [ ("A", [] :: [Int])
                               , ("B", [1, 2, 3, 4,  5])
                               , ("C", [1, 3, 5, 7,  9])
                               , ("D", [2, 4, 6, 8, 10])
                               , ("E", [2, 3, 5, 7])
                               , ("F", [8])]
