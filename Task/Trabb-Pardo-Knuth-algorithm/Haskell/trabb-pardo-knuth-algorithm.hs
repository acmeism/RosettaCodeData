import Control.Monad (replicateM, mapM_)

f :: Floating a => a -> a
f x = sqrt (abs x) + 5 * x ** 3

main :: IO ()
main = do
  putStrLn "Enter 11 numbers for evaluation"
  x <- replicateM 11 readLn
  mapM_
    ((\x ->
         if x > 400
           then putStrLn "OVERFLOW"
           else print x) .
     f) $
    reverse x
