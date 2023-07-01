import Data.List.Split ( chunksOf )

isGeneralizedCurzon :: Integer -> Integer -> Bool
isGeneralizedCurzon base n = mod ( base ^ n + 1 ) ( base * n + 1 ) == 0

solution :: Integer -> [Integer]
solution base = take 50 $ filter (\i -> isGeneralizedCurzon base i ) [1..]

printChunk :: [Integer] -> String
printChunk chunk = foldl1 (++) $ map (\i -> (take ( 4 - (length $ show i) )
 $ repeat ' ' ) ++ show i ++ " ") chunk

prettyPrint :: [Integer] -> [String]
prettyPrint list = map printChunk $ chunksOf 10 list

oneThousandth :: Integer -> Integer
oneThousandth base = last $ take 950 $ filter (\i -> isGeneralizedCurzon base i )
 [(last $ solution base) + 1 ..]

printBlock :: Integer -> [String]
printBlock base = ["first 50 Curzon numbers using a base of " ++ show base ++ " :"]
 ++  (prettyPrint $ solution base) ++ ["one thousandth at base " ++ show base ++
  ": " ++ (show $ oneThousandth base)] ++ [take 50 $ repeat '-']

main :: IO ( )
main = do
   blocks <- return $ concat $ map (\i -> printBlock i ) [2 , 4 , 6 , 8 , 10]
   mapM_ putStrLn blocks
