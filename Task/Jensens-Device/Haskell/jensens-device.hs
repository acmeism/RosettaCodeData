import Control.Monad.ST
import Data.STRef

sum_ :: STRef s Double -> Double -> Double
     -> ST s Double -> ST s Double
sum_ ref lo hi term =
   do
     vs <- forM [lo .. hi]
            (\k -> do { writeSTRef ref k
                      ; term } )
     return $ sum vs

foo :: Double
foo =
  runST $
  do ref <- newSTRef undefined
          -- initial value doesn't matter
     sum_ ref 1 100 $
       do
         k <- readSTRef ref
         return $ recip k

main :: IO ()
main = print foo
