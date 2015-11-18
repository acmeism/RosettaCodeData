import System.Environment
import Control.Concurrent
import Control.Concurrent.Async

sleepSort :: [Int] -> IO [()]
sleepSort = mapConcurrently (\x -> threadDelay (x*10^4) >> print x)

main :: IO [()]
main = getArgs >>= sleepSort . map read
