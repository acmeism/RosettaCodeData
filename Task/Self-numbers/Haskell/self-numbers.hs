import Control.Monad (forM_)
import Text.Printf

selfs :: [Integer]
selfs = sieve (sumFs [0..]) [0..]
  where
    sumFs = zipWith (+) [ a+b+c+d+e+f+g+h+i+j
                        | a <- [0..9] , b <- [0..9]
                        , c <- [0..9] , d <- [0..9]
                        , e <- [0..9] , f <- [0..9]
                        , g <- [0..9] , h <- [0..9]
                        , i <- [0..9] , j <- [0..9] ]

    -- More idiomatic list generator is about three times slower
    --  sumFs = zipWith (+) $ sum <$> replicateM  10 [0..9]

    sieve (f:fs) (n:ns)
      | n > f = sieve fs (n:ns)
      | n `notElem` take 81 (f:fs) = n : sieve (f:fs) ns
      | otherwise = sieve (f:fs) ns

main = do
  print $ take 50 selfs
  forM_ [1..8] $ \i ->
    printf "1e%v\t%v\n" (i :: Int) (selfs !! (10^i-1))
