import Control.Monad (foldM)

calcRPNIO :: String -> IO [Double]
calcRPNIO = foldM (verbose interprete) [] . words

verbose f s x = write (x ++ "\t" ++ show res ++ "\n") >> return res
  where res = f s x
