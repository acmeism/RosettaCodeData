import Data.List
import System.Random
import Control.Monad
import Control.Arrow
import Data.Ord

vecLeng [[a,b],[p,q]] = sqrt $ (a-p)^2+(b-q)^2

findClosestPair =  foldl1' ((minimumBy (comparing vecLeng). ). (. return). (:)) .
                   concatMap (\(x:xs) -> map ((x:).return) xs) . init . tails

testCP = do
    g <- newStdGen
    let pts :: [[Double]]
        pts = take 1000. unfoldr (Just. splitAt 2) $ randomRs(-1,1) g
    print . (id &&& vecLeng ) . findClosestPair $ pts
