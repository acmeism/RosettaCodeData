import System.Environment (getArgs)

plotChar :: Int -> Float -> Float -> Float -> Float -> Char
plotChar iter cReal cImag y x
  | zReal^2 > 10000 = ' '
  | iter == 1       = '#'
  | otherwise       = plotChar (pred iter) cReal cImag zImag zReal
 where
  zReal = x * x - y * y + cReal
  zImag = x * y * 2 + cImag

parseArgs :: [String] -> (Float, Float)
parseArgs []             = (-0.8, 0.156)
parseArgs [cReal, cImag] = (read cReal :: Float, read cImag :: Float)
parseArgs _              = error "Invalid arguments"

main :: IO ()
main = do
  args <- getArgs
  let (cReal, cImag) = parseArgs args
  print (cReal, cImag)
  mapM_ putStrLn $ [-100,-96..100] >>= \y ->
    [[-280,-276..280] >>= \x -> [plotChar 50 cReal cImag (y/100) (x/200)]]
