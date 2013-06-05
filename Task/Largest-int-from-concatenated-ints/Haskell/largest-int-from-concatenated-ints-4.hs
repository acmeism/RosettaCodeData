import Data.List (sort, permutations)

main = print (map maxcat [[1,34,3,98,9,76,45,4], [54,546,548,60]] :: [Integer])
    where maxcat = read . last . sort . map (concat . map show) . permutations
