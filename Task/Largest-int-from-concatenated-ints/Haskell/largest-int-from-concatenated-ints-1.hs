import Data.List (sortBy)
import Data.Ord (comparing)

main = print (map maxcat [[1,34,3,98,9,76,45,4], [54,546,548,60]] :: [Integer])
    where sorted = sortBy (flip $ comparing $ take 10 . cycle)
          maxcat = read . concat . sorted . map show
