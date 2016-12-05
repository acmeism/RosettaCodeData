import Data.List (intercalate)

showFactors n = show n ++ " = " ++ (intercalate " * " . map show . factorize) n
-- Pointfree form
showFactors = ((++) . show) <*> ((" = " ++) . intercalate " * " . map show . factorize)
