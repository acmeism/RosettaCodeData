{-# LANGUAGE Strict,FlexibleInstances #-}
module KMeans where

import Control.Applicative
import Control.Monad.Random
import Data.List (minimumBy, genericLength, transpose)
import Data.Ord (comparing)
import qualified Data.Map.Strict as M


type Vec = [Float]
type Cluster = [Vec]

kMeansIteration :: [Vec] -> [Vec] -> [Cluster]
kMeansIteration pts = clusterize . fixPoint iteration
  where
    iteration = map centroid . clusterize

    clusterize centroids = M.elems $ foldr add m0 pts
      where add x = M.insertWith (++) (centroids `nearestTo` x) [x]
            m0 = M.unions $ map (`M.singleton` []) centroids

nearestTo :: [Vec] -> Vec -> Vec
nearestTo pts x =  minimumBy (comparing (distance x)) pts

distance :: Vec -> Vec -> Float
distance a b = sum $ map (^2) $ zipWith (-) a b

centroid :: [Vec] -> Vec
centroid = map mean . transpose
  where  mean pts = sum pts / genericLength pts

fixPoint :: Eq a => (a -> a) -> a -> a
fixPoint f x = if x == fx then x else fixPoint f fx where fx = f x

-- initial sampling

kMeans :: MonadRandom m => Int -> [Vec] -> m [Cluster]
kMeans n pts = kMeansIteration pts <$> take n <$> randomElements pts

kMeansPP :: MonadRandom m => Int -> [Vec] -> m [Cluster]
kMeansPP n pts = kMeansIteration pts <$> centroids
  where centroids = iterate (>>= nextCentroid) x0 !! (n-1)
        x0 = take 1 <$> randomElements pts
        nextCentroid cs = (: cs) <$> fromList (map (weight cs) pts)
        weight cs x = (x, toRational $ distance x (cs `nearestTo` x))

randomElements :: MonadRandom m => [a] -> m [a]
randomElements pts = map (pts !!) <$> getRandomRs (0, length pts)

-- sample cluster generation

instance (RandomGen g, Monoid m) => Monoid (Rand g m) where
   mempty = pure mempty
   mappend = liftA2 mappend

mkCluster n s m = take n . transpose <$> mapM randomsAround m
  where randomsAround x0 = map (\x -> x0+s*atanh x) <$> getRandomRs (-1,1)
