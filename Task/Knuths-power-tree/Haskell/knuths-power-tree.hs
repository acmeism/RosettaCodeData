{-# LANGUAGE ScopedTypeVariables #-}

module Rosetta.PowerTree
    ( Natural
    , powerTree
    , power
    )  where

import           Data.Foldable (toList)
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import           Data.Maybe (fromMaybe)
import           Data.List (foldl')
import           Data.Sequence (Seq (..), (|>))
import qualified Data.Sequence as Seq
import           Numeric.Natural (Natural)

type M = Map Natural S
type S = Seq Natural

levels :: [M]
levels = let s = Seq.singleton 1 in fst <$> iterate step (Map.singleton 1 s, s)

step :: (M, S) -> (M, S)
step (m, xs) = foldl' f (m, Empty) xs
  where
    f :: (M, S) -> Natural -> (M, S)
    f (m', ys) n = foldl' g (m', ys) ns
      where
        ns :: S
        ns = m' Map.! n

        g :: (M, S) -> Natural -> (M, S)
        g (m'', zs) k =
            let l = n + k
            in  case Map.lookup l m'' of
                    Nothing -> (Map.insert l (ns |>  l) m'', zs |> l)
                    Just _  -> (m'', zs)

powerTree :: Natural -> [Natural]
powerTree n
    | n <= 0    = []
    | otherwise = go levels
  where
    go :: [M] -> [Natural]
    go []       = error "impossible branch"
    go (m : ms) = fromMaybe (go ms) $ toList <$> Map.lookup n m

power :: forall a. Num a => a -> Natural -> a
power _ 0 = 1
power a n = go a 1 (Map.singleton 1 a) $ tail $ powerTree n
  where
    go :: a -> Natural -> Map Natural a -> [Natural] -> a
    go b _ _ []       = b
    go b k m (l : ls) =
        let b' = b * m Map.! (l - k)
            m' = Map.insert l b' m
        in  go b' l m' ls
