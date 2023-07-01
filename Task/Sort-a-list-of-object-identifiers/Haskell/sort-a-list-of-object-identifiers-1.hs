import Data.List ( sort , intercalate )

splitString :: Eq a => (a) -> [a] -> [[a]]
splitString c [] = []
splitString c s = let ( item , rest ) = break ( == c ) s
                      ( _ , next ) = break ( /= c ) rest
		  in item : splitString c next

convertIntListToString :: [Int] -> String
convertIntListToString = intercalate "." . map show

orderOID :: [String] -> [String]
orderOID = map convertIntListToString . sort . map ( map read . splitString '.' )

oid :: [String]
oid = ["1.3.6.1.4.1.11.2.17.19.3.4.0.10" ,
    "1.3.6.1.4.1.11.2.17.5.2.0.79" ,
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4" ,
    "1.3.6.1.4.1.11150.3.4.0.1" ,
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1" ,
    "1.3.6.1.4.1.11150.3.4.0"]

main :: IO ( )
main = do
   mapM_ putStrLn $ orderOID oid
