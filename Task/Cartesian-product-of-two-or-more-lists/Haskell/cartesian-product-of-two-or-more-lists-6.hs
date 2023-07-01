cartProdN :: [[a]] -> [[a]]
cartProdN = sequence

main :: IO ()
main = print $ cartProdN [[1, 2], [3, 4], [5, 6]]
