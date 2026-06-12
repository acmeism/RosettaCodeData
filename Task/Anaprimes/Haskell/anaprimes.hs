import Data.List ( sort , sortOn , groupBy )
import Data.Maybe ( fromJust )

isPrime :: Int -> Bool
isPrime n
   |n == 0 = False
   |n == 1 = False
   |n == 2 = True
   |otherwise = all (\i -> mod n i /= 0 ) [2..limit]
    where
     limit = floor $ sqrt $ fromIntegral n

findAnaprimes :: Int -> Int -> [[Int]]
findAnaprimes from to =
   let
      primePairs = zip [0, 1 ..] ( filter isPrime [from..to] )
      converted = map (\p -> ( fst p , sort $ show $ snd p )) primePairs
      sorted = sortOn snd converted
      grouped = groupBy (\p1 p2 -> snd p1 == snd p2 ) sorted
   in map (\subli -> map (\p -> fromJust $ lookup ( fst p ) primePairs ) subli)
    grouped


result :: Int -> Int -> (Int , Int , Int , (Int , Int))
result from to =
   let anaprimes = findAnaprimes from to
       sorted = sortOn length anaprimes
       longest = length $ last sorted
   in ( length $ filter ( (> 1 ) . length ) anaprimes , longest , length $ filter
    ((== longest ) . length ) sorted , ( head $ last sorted , last $ last sorted ))

printResult :: (Int , Int , Int , (Int , Int)) -> String
printResult ( anaprimes , longestRun, numberOfRuns , (smallestInRun , largestInRun) ) =
 "number of anaprimes : " ++ ( show anaprimes ) ++ " , longest run : " ++ ( show
  longestRun ) ++ " members, number of longest runs " ++ ( show numberOfRuns ) ++
 " , range" ++ " from " ++ ( show smallestInRun ) ++ " to " ++ ( show largestInRun )

main :: IO ( )
main = do
   putStrLn "anaprimes 3 digits long:"
   putStrLn (printResult $ result 10 1000)
   putStrLn "anaprimes 4 digits long:"
   putStrLn ( printResult $ result 10 10000 )
   putStrLn "anaprimes 5 digits long:"
   putStrLn ( printResult $ result 10 100000 )
   putStrLn "anaprimes 6 digits long:"
   putStrLn ( printResult $ result 10 1000000 )
