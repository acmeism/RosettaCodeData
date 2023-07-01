import Data.List
import Control.Arrow
import Control.Monad
import Data.Maybe

dblflipIt :: (Ord a) => [a] -> [a]
dblflipIt = uncurry ((reverse.).(++)). first reverse
  . ap (flip splitAt) (succ. fromJust. (elemIndex =<< maximum))

dopancakeSort :: (Ord a) => [a] -> [a]
dopancakeSort xs = dopcs (xs,[]) where
  dopcs ([],rs) = rs
  dopcs ([x],rs) = x:rs
  dopcs (xs,rs) = dopcs $ (init &&& (:rs).last ) $ dblflipIt xs
