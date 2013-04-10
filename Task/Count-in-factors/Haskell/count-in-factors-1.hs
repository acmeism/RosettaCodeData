import Data.List (intercalate)

showFactors n = show n ++ " = " ++ (intercalate " * " . map show . factorize) n
