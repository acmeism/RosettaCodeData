import Data.Map (Map, empty, insert, findWithDefault, toList)
import Data.Maybe (fromMaybe)
import Text.Printf (printf)
import Data.Function (on)
import Data.List (sort, maximumBy, minimumBy)
import Control.Monad.Random (RandomGen, Rand, evalRandIO, getRandomR)
import Control.Monad (replicateM)

-- Box-Muller
getNorm :: RandomGen g => Rand g Double
getNorm = do
    u0 <- getRandomR (0.0, 1.0)
    u1 <- getRandomR (0.0, 1.0)
    let r = sqrt $ (-2.0) * log u0
        theta = 2.0 * pi * u1
    return $ r * sin theta

putInBin :: Double -> Map Int Int -> Double -> Map Int Int
putInBin binWidth t v =
    let bin = round (v / binWidth)
        count = findWithDefault 0 bin t
    in insert bin (count+1) t

runTest :: Int -> IO ()
runTest n = do
    rs <- evalRandIO $ replicateM n getNorm
    let binWidth = 0.1

        tally v (sv, sv2, t) = (sv+v, sv2 + v*v, putInBin binWidth t v)

        (sum, sum2, tallies) = foldr tally (0.0, 0.0, empty) rs

        tallyList = sort $ toList tallies

        printStars tallies binWidth maxCount selection =
            let count = findWithDefault 0 selection tallies
                bin = binWidth * fromIntegral selection
                maxStars = 100
                starCount = if maxCount <= maxStars
                            then count
                            else maxStars * count `div` maxCount
                stars = replicate  starCount '*'
            in printf "%5.2f: %s  %d\n" bin stars count

        mean = sum / fromIntegral n
        stddev = sqrt (sum2/fromIntegral n - mean*mean)

    printf "\n"
    printf "sample count: %d\n" n
    printf "mean:         %9.7f\n" mean
    printf "stddev:       %9.7f\n" stddev

    let maxCount = snd $ maximumBy (compare `on` snd) tallyList
        maxBin = fst $ maximumBy (compare `on` fst) tallyList
        minBin = fst $ minimumBy (compare `on` fst) tallyList

    mapM_ (printStars tallies binWidth maxCount) [minBin..maxBin]

main = do
    runTest 1000
    runTest 2000000
