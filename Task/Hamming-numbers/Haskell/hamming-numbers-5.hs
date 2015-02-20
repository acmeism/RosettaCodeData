-- directly find n-th Hamming number, in ~ O(n^{2/3}) time
-- by Will Ness, based on "top band" idea by Louis Klauder, from DDJ discussion
--   http://drdobbs.com/blogs/architecture-and-design/228700538

{-# OPTIONS -O2 -XBangPatterns #-}
import Data.List (sortBy)
import Data.Function (on)

main = let (r,t) = nthHam 1000000 in print t >> print (trival t)

lg3 = logBase 2 3;  lg5 = logBase 2 5
logval (i,j,k)    = fromIntegral i + fromIntegral j*lg3 + fromIntegral k*lg5
trival (i,j,k)    = 2^i * 3^j * 5^k
estval n          = (6*lg3*lg5* fromIntegral n)**(1/3)  -- estimated logval, base 2
rngval n
    | n > 500000  = (2.4496 , 0.0076 )                  -- empirical estimation
    | n > 50000   = (2.4424 , 0.0146 )                  --   correction, base 2
    | n > 500     = (2.3948 , 0.0723 )                  --     (dist,width)
    | n > 1       = (2.2506 , 0.2887 )                  -- around (log $ sqrt 30),
    | otherwise   = (2.2506 , 0.5771 )                  --   says WP

nthHam :: Int -> (Double, (Int, Int, Int))
nthHam n                                                   -- n: 1-based: 1,2,3...
  | w >= 1    = error $ "Breach of contract: (w < 1):  " ++ show w
  | m <  0    = error $ "Not enough triples generated: " ++ show (c,n)
  | m >= nb   = error $ "Generated band is too narrow: " ++ show (m,nb)
  | otherwise = res
 where
  (d,w)   = rngval n                                     -- correction dist, width
  hi      = estval n - d                                 --   hi > logval > hi-w
  (m,nb)  = ( fromIntegral $ c - n, length b )           -- m 0-based from top, |band|
  (s,res) = ( sortBy (flip compare `on` fst) b, s!!m )   -- sorted decreasing, result
  (c,b)   = f 0                                          -- total count, the band
              [ ( i+1,                                   -- total triples w/ this (j,k)
                  [ (r,(i,j,k)) | frac < w ] )           -- store it, if inside band
                | k <- [ 0 .. floor ( hi   /lg5) ],  let p = fromIntegral k*lg5,
                  j <- [ 0 .. floor ((hi-p)/lg3) ],  let q = fromIntegral j*lg3 + p,
                  let (i,frac) = pr  (hi-q) ;            r = hi-frac ] -- r = i + q
         -- f 0 z == (sum $ map fst z, concat $ map snd z)
    where pr = properFraction
          f !c []          = (c,[])                      -- code as a loop
          f !c ((c1,b1):r) = let (cr,br) = f (c+c1) r    --   to prevent space leak
                             in case b1 of { [v] -> (cr,v:br)
                                           ;  _  -> (cr, br) }
