import  Data.Random
import Control.Monad

thousandRandomNumbers :: RVar [Double]
thousandRandomNumbers =  replicateM 1000 $ normal 1 0.5

main = do
   x <- sample thousandRandomNumbers
   print x
