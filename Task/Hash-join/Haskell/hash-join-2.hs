{-# LANGUAGE TupleSections #-}
import qualified Data.Map as M
import Data.List
import Data.Maybe
import Control.Applicative

mapJoin xs fx ys fy = joined
  where yMap = foldl' f M.empty ys
        f m y = M.insertWith (++) (fy y) [y] m
        joined = concat . catMaybes .
                 map (\x -> map (x,) <$> M.lookup (fx x) yMap) $ xs

test = mapM_ print $ mapJoin
    [(1, "Jonah"), (2, "Alan"), (3, "Glory"), (4, "Popeye")]
        snd
    [("Jonah", "Whales"), ("Jonah", "Spiders"),
     ("Alan", "Ghosts"), ("Alan", "Zombies"), ("Glory", "Buffy")]
        fst
