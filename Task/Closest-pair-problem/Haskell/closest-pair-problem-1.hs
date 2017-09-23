import Data.List (minimumBy, tails, unfoldr, foldl1') --'

import System.Random (newStdGen, randomRs)

import Control.Arrow ((&&&))

import Data.Ord (comparing)

vecLeng [[a, b], [p, q]] = sqrt $ (a - p) ^ 2 + (b - q) ^ 2

findClosestPair =
  foldl1'' ((minimumBy (comparing vecLeng) .) . (. return) . (:)) .
  concatMap (\(x:xs) -> map ((x :) . return) xs) . init . tails

testCP = do
  g <- newStdGen
  let pts :: [[Double]]
      pts = take 1000 . unfoldr (Just . splitAt 2) $ randomRs (-1, 1) g
  print . (id &&& vecLeng) . findClosestPair $ pts

main = testCP

foldl1'' = foldl1'
