{-# OPTIONS -O2 -XBangPatterns #-}

import Data.Word
import Data.List (sortBy)
import Data.Function (on)

main = let t = nthHam 1000000000000 in print t >> print (trival t)

lb3 = logBase 2 3;  lb5 = logBase 2 5
lbrt30 = logBase 2 $ sqrt 30 :: Double -- estimate adjustment as per WP
trival (i,j,k)    = 2^i * 3^j * 5^k
estval2 n         = (6*lb3*lb5*n)**(1/3) - lbrt30 -- estimated logval, base 2
crctn n
    | n < 1000       = 0.509  -- empirical correction terms
    | n < 1000000    = 0.206
    | n < 1000000000 = 0.122  -- further divisions have little effect as already small
    | otherwise      = 0.105  -- very slowly decrease from this point for a billion

nthHam :: Word64 -> (Int, Int, Int)
nthHam n                                                   -- n: 1-based 1,2,3...
  | n < 2     = case n of
                  0 -> error "nthHam:  Argument is zero!"
                  _ -> (0, 0, 0)                           -- trivial case for 1
  | m <  0    = error $ "Not enough triples generated: " ++ show (c,n)
  | m >= nb   = error $ "Generated band is too narrow: " ++ show (m,nb)
  | otherwise = case res of (_, tv) -> tv -- 2^i * 3^j * 5^k
 where
  (fr,est)= (crctn n, estval2 $ fromIntegral n)           -- fraction of log2 error, est val
  (hi,lo) = (estval2 (fromIntegral n + fr*est), 2*est-hi) -- hi > logval2 > hi-w
  (c,b)   = let klmt = floor (hi/lb5) in
            let loopk k !ck bndk =
                  if k > klmt then (ck, bndk) else
                  let p = fromIntegral k*lb5; jlmt = floor ((hi-p)/lb3) in
                  let loopj j !cj bndj =
                        if j > jlmt then loopk (k+1) cj bndj else
                        let q = fromIntegral j*lb3 + p in
                        let (i, frac) = properFraction (hi-q); r = hi-frac in
                        if r < lo then loopj (j+1) (fromIntegral i+cj+1) bndj else
                        loopj (j+1) (fromIntegral i+cj+1) ((r,(i,j,k)):bndj) in
                  loopj 0 ck bndk in
            loopk 0 0 []
  (m,nb)    = ( fromIntegral $ c - n, length b )         -- m 0-based from top, |band|
  (s,res)   = ( sortBy (flip compare `on` fst) b, s!!m ) -- sorted decreasing, result<
