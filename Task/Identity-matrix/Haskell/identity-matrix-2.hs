showMat :: [[Int]] -> String
showMat = unlines . map (unwords . map show)
