import Data.List.Split ( chunksOf )
import Data.List ( (!!) )

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

isMagnanimous :: Int -> Bool
isMagnanimous n = all isPrime $ map (\p -> fst p + snd p ) numberPairs
 where
  str:: String
  str = show n
  splitStrings :: [(String , String)]
  splitStrings = map (\i -> splitAt i str) [1 .. length str - 1]
  numberPairs :: [(Int , Int)]
  numberPairs = map (\p -> ( read $ fst p , read $ snd p )) splitStrings

printInWidth :: Int -> Int -> String
printInWidth number width = replicate ( width - l ) ' ' ++ str
 where
  str :: String
  str = show number
  l :: Int
  l = length str

solution :: [Int]
solution = take 400 $ filter isMagnanimous [0 , 1 ..]

main :: IO ( )
main = do
   let numbers = solution
       numberlines = chunksOf 10 $ take 45 numbers
   putStrLn "First 45 magnanimous numbers:"
   mapM_ (\li -> putStrLn (foldl1 ( ++ ) $ map (\n -> printInWidth n 6 )
    li )) numberlines
   putStrLn "241'st to 250th magnanimous numbers:"
   putStr $ show ( numbers !! 240 )
   putStrLn ( foldl1 ( ++ ) $ map(\n -> printInWidth n 8 ) $ take 9 $
    drop 241 numbers )
   putStrLn "391'st to 400th magnanimous numbers:"
   putStr $ show ( numbers !! 390 )
   putStrLn ( foldl1 ( ++ ) $ map(\n -> printInWidth n 8 ) $ drop 391 numbers)
