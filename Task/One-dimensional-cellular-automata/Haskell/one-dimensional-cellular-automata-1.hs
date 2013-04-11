module Life1D where

import Data.List
import System.Random
import Control.Monad
import Control.Arrow

bnd :: [Char] -> Char
bnd bs =
   case bs of
        "_##" -> '#'
        "#_#" -> '#'
        "##_" -> '#'
        _     -> '_'

donxt xs = unfoldr(\xs -> case xs of [_,_] -> Nothing ;
                                      _ -> Just (bnd $ take 3 xs, drop 1 xs))  $ '_':xs++"_"

lahmahgaan xs = init.until (liftM2 (==) last (last. init)) (ap (++)(return. donxt. last)) $ [xs, donxt xs]

main = do
   g <- newStdGen
   let oersoep = map ("_#"!!). take 36 $ randomRs(0,1) g
   mapM_ print . lahmahgaan $ oersoep
