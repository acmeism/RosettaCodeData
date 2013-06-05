import Data.List (sortBy)
import Data.Ord (comparing)

main = print (map maxcat [[1,34,3,98,9,76,45,4], [54,546,548,60]] :: [Integer])
    where
      sorted xs = let pad x  = concat $ replicate (maxLen `div` length x + 1) x
                      maxLen = maximum $ map length xs
                  in  sortBy (flip $ comparing pad) xs

      maxcat = read . concat . sorted . map show
