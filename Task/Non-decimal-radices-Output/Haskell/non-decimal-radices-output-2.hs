import Numeric

main :: IO ()
main = mapM_ f [0..33] where
  f :: Int -> IO ()
  f n = putStrLn $ " " ++ showOct n "" ++ " " ++ show n ++ " " ++ showHex n ""
