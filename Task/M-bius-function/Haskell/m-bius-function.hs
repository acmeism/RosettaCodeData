import Data.List (intercalate)
import Data.List.Split (chunksOf)
import Data.Vector.Unboxed (toList)
import Math.NumberTheory.ArithmeticFunctions.Moebius (Moebius(..),
                                                      sieveBlockMoebius)
import System.Environment (getArgs, getProgName)
import System.IO (hPutStrLn, stderr)
import Text.Read (readMaybe)

-- Calculate the Möbius function, μ(n), for a sequence of values starting at 1.
moebiusBlock :: Word -> [Moebius]
moebiusBlock = toList . sieveBlockMoebius 1

showMoebiusBlock :: Word -> [Moebius] -> String
showMoebiusBlock cols = intercalate "\n" . map (concatMap showMoebius) .
                        chunksOf (fromIntegral cols)
  where showMoebius MoebiusN = " -1"
        showMoebius MoebiusZ = "  0"
        showMoebius MoebiusP = "  1"

main :: IO ()
main = do
  prog <- getProgName
  args <- map readMaybe <$> getArgs
  case args of
    [Just cols, Just n] ->
      putStrLn ("μ(n) for 1 ≤ n ≤ " ++ show n ++ ":\n") >>
      putStrLn (showMoebiusBlock cols $ moebiusBlock n)
    _ -> hPutStrLn stderr $ "Usage: " ++ prog ++ " num-columns maximum-number"
