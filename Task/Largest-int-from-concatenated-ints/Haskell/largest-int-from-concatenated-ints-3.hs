import Data.List (sortBy)

main = print (map maxcat [[1,34,3,98,9,76,45,4], [54,546,548,60]] :: [Integer])
    where sorted = sortBy (\a b -> compare (b++a) (a++b))
          maxcat = read . concat . sorted . map show
