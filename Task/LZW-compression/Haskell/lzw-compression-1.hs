import Data.List
import Data.Char
import Data.Maybe
import Control.Monad
import Control.Arrow

take2 = filter((==2).length). map (take 2). tails

doLZW _ [] = []
doLZW as (x:xs) =  lzw (map return as) [x] xs
   where lzw a w [] = [fromJust $ elemIndex w a]
         lzw a w (x:xs)  | w' `elem` a = lzw a w' xs
                         | otherwise   = fromJust (elemIndex w a) : lzw (a++[w']) [x] xs
              where w' = w++[x]

undoLZW _ [] = []
undoLZW a cs =
  ((cs >>=).(!!)) $
  foldl (liftM2 (.) (++) (((return. liftM2 (++) head (take 1. last)).). map. (!!)))
  (map return a) (take2 cs)
