import Data.Char (chr)
import Data.List (transpose)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

----------------------- ASCII TABLE ----------------------

asciiTable :: String
asciiTable =
  unlines $
    (printf "%-12s" =<<)
      <$> transpose
        (chunksOf 16 $ asciiEntry <$> [32 .. 127])

asciiEntry :: Int -> String
asciiEntry n
  | null k = k
  | otherwise = concat [printf "%3d" n, " : ", k]
  where
    k = asciiName n

asciiName :: Int -> String
asciiName n
  | 32 > n = []
  | 127 < n = []
  | 32 == n = "Spc"
  | 127 == n = "Del"
  | otherwise = [chr n]


--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn asciiTable
