import Text.Printf
import Data.List

juggler :: Integer -> [Integer]
juggler = takeWhile (> 1) . iterate (\x -> if odd x
                                           then isqrt (x*x*x)
                                           else isqrt x)

task :: Integer -> IO ()
task n = printf s n (length ns + 1) (i :: Int) (showMax m)
  where
    ns = juggler n
    (m, i) = maximum $ zip ns [0..]
    s = "n = %d length = %d maximal value at = %d (%s)\n"
    showMax n = let s = show n
                in if n > 10^100
                   then show (length s) ++ " digits"
                   else show n

main = do
  mapM_ task [20..39]
  putStrLn "\nTough guys\n"
  mapM_ task [ 113, 173, 193, 2183, 11229, 15065, 15845, 30817 ]
