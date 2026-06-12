import Data.List ( (!!) )

splitString :: Char -> String -> [String]
splitString c [] = []
splitString c s = let ( item , rest ) = break ( == c ) s
                      ( _ , next ) = break ( /= c ) rest
		  in item : splitString c next
		
computeUsage :: String -> Double
computeUsage s = (1.0 - ((lineElements !! 3 ) /  sum times)) * 100
   where
      lineElements = map (fromInteger . read ) $ tail $ splitString ' ' s
      times = tail lineElements

main :: IO ( )
main = do
   theTimes <- fmap lines $ readFile "/proc/stat"
   putStr $ show $ computeUsage $ head theTimes
   putStrLn " %"
