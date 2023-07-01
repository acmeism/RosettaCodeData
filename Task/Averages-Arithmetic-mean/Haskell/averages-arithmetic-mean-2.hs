meanReals :: (Real a, Fractional b) => [a] -> b
meanReals = mean . map realToFrac
