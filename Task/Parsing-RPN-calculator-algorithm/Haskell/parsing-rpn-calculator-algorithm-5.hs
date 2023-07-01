calcRPNM :: Logger m => String -> m [Double]
calcRPNM = foldM (verbose interprete) [] . words
