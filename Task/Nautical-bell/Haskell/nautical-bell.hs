import Control.Concurrent
import Control.Monad
import Data.Time
import Text.Printf

type Microsecond = Int
type Scheduler = TimeOfDay -> Microsecond

-- Scheduling
--------------

getTime :: TimeZone -> IO TimeOfDay
getTime tz = do
    t  <- getCurrentTime
    return $ localTimeOfDay $ utcToLocalTime tz t

getGMTTime   = getTime utc
getLocalTime = getCurrentTimeZone >>= getTime

-- Returns the difference between 'y' and the closest higher multiple of 'x'
nextInterval x y
    | x > y = x - y
    | mod y x > 0 = x - mod y x
    | otherwise = 0

-- Given a interval in seconds, this function returns time delta in microseconds.
onInterval :: Int -> Scheduler
onInterval interval time = toNext dMS
  where
    toNext = nextInterval (1000000 * interval)
    tDelta = timeOfDayToTime time
    dMS    = truncate $ 1000000 * tDelta

doWithScheduler :: Scheduler -> (Int -> IO ()) -> IO ThreadId
doWithScheduler sched task = forkIO $ forM_ [0..] exec
  where
    exec n = do
        t <- getLocalTime
        threadDelay $ sched t
        task n

-- Output
---------

watchNames = words "Middle Morning Forenoon Afternoon Dog First"
countWords = words "One Two Three Four Five Six Seven Eight"

-- Executes IO action and then waits for n microseconds
postDelay n fn = fn >> threadDelay n

termBell        = putStr "\a"
termBells n     = replicateM_ n $ postDelay 100000 termBell
termBellSeq seq = forM_ seq $ postDelay 500000 . termBells

toNoteGlyph 1 = "♪"
toNoteGlyph 2 = "♫"
toNoteGlyph _ = ""

ringBells :: Int -> IO ()
ringBells n = do
    t <- getLocalTime
    let numBells    = 1 + (mod n 8)
        watch       = watchNames!!(mod (div n 8) 8)
        count       = countWords!!(numBells - 1)
        (twos,ones) = quotRem numBells 2
        pattern     = (replicate twos 2) ++ (replicate ones 1)
        notes       = unwords $ map toNoteGlyph pattern
        plural       = if numBells > 1 then "s" else ""
        strFMT      = show t ++ ": %s watch, %5s bell%s:  " ++ notes ++ "\n"
    printf strFMT watch count plural
    termBellSeq pattern

-- Usage
---------

bellRinger :: IO ThreadId
bellRinger = doWithScheduler (onInterval (30*60)) ringBells
