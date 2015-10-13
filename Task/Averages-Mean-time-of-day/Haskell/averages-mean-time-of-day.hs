import Data.Complex (cis, phase)
import Data.List.Split (splitOn)
import Text.Printf (printf)

timeToRadians :: String -> Float
timeToRadians time =
        let hours:minutes:seconds:_ = splitOn ":" time
            s = fromIntegral (read seconds :: Int)
            m = fromIntegral (read minutes :: Int)
            h = fromIntegral (read hours :: Int)
        in  (2*pi)*(h+ (m + s/60.0 )/60.0 )/24.0

radiansToTime :: Float -> String
radiansToTime  r =
        let tau = pi*2
            (_,fDay) = properFraction (r / tau) :: (Int, Float)
            fDayPositive = if fDay < 0 then 1.0+fDay else fDay
            (hours, fHours) = properFraction $ 24.0 * fDayPositive
            (minutes, fMinutes) = properFraction $ 60.0 * fHours
            seconds = 60.0 * fMinutes
        in printf "%0d" (hours::Int) ++ ":" ++ printf "%0d" (minutes::Int) ++ ":" ++ printf "%0.0f" (seconds::Float)

meanAngle :: [Float] -> Float
meanAngle = phase . sum . map cis

main :: IO ()
main = putStrLn $ radiansToTime $ meanAngle $ map timeToRadians ["23:00:17", "23:40:20", "00:12:45", "00:17:19"]
