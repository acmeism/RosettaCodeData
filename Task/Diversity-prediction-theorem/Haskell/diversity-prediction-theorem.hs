mean :: (Fractional a, Foldable t) => t a -> a
mean lst = sum lst / fromIntegral (length lst)

meanSq :: Fractional c => c -> [c] -> c
meanSq x = mean . map (\y -> (x-y)^^2)

diversityPrediction x estimates = do
   putStrLn $ "TrueValue:\t" ++ show x
   putStrLn $ "CrowdEstimates:\t" ++ show estimates
   let avg = mean estimates
   let avgerr = meanSq x estimates
   putStrLn $ "AverageError:\t" ++ show avgerr
   let crowderr = (x - avg)^^2
   putStrLn $ "CrowdError:\t" ++ show crowderr
   let diversity = meanSq avg estimates
   putStrLn $ "Diversity:\t" ++ show diversity
