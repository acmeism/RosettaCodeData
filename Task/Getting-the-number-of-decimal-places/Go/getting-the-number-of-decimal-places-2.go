decimal :: String -> Int
decimal [] = 0
decimal ('.':xs) = length xs
decimal (_:xs) = decimal xs

numDecimal :: Double -> Int
numDecimal = decimal . show

main = print . map numDecimal $ [12.0, 12.345, 12.3450, 12.345555555555, 12.34555555555555555555, 1.2345e+54]
