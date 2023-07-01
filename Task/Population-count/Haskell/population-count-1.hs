import Data.Bits (popCount)

printPops :: (Show a, Integral a) => String -> [a] -> IO ()
printPops title counts = putStrLn $ title ++ show (take 30 counts)

main :: IO ()
main = do
  printPops "popcount " $ map popCount $ iterate (*3) (1 :: Integer)
  printPops "evil     " $ filter (even . popCount) ([0..] :: [Integer])
  printPops "odious   " $ filter ( odd . popCount) ([0..] :: [Integer])
