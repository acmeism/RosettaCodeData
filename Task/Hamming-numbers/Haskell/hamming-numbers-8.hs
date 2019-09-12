{-# OPTIONS_GHC -O3 -XStrict #-}

import Data.Word
import Data.List (sortBy)
import Data.Function (on)

nthHam :: Word64 -> (Int, Int, Int)
nthHam n                                               -- n: 1-based 1,2,3...
  | n < 2     = case n of
                  0 -> error "nthHam:  Argument is zero!"
                  _ -> (0, 0, 0)                       -- trivial case for 1
  | m <  0    = error $ "Not enough triples generated: " ++ show (c,n)
  | m >= nb   = error $ "Generated band is too narrow: " ++ show (m,nb)
  | otherwise = case res of (_, tv) -> tv -- 2^i * 3^j * 5^k
 where
  lb3     = logBase 2 3; lb5 = logBase 2 5.0
  lbrt30  = logBase 2 $ sqrt 30 :: Double -- estimate adjustment as per WP
  lg2est  = (6 * lb3 * lb5 * fromIntegral n)**(1/3) - lbrt30 -- estimated logval, base 2
  (hi,lo) = (lg2est + 1/lg2est, 2 * lg2est - hi) -- hi > log2est > lo
  bglb2 = 1267650600228229401496703205376 :: Integer
  bglb3 = 2009178665378409109047848542368 :: Integer
  bglb5 = 2943393543170754072109742145491 :: Integer
  (c, b)  = let klmt = floor (hi / lb5)
                loopk k ck bndk =
                  if k > klmt then (ck, bndk) else
                  let p = hi - fromIntegral k * lb5; jlmt = floor (p / lb3)
                      loopj j cj bndj =
                        if j > jlmt then loopk (k + 1) cj bndj else
                        let q = p - fromIntegral j * lb3
                            (i, frac) = properFraction q
                            nj = j + 1; ncj = cj + fromIntegral i + 1
                            r = hi - frac
                            nbndj = i `seq` bndj `seq`
                                    if r < lo then bndj
                                    else
                                      let bglg = bglb2 * fromIntegral i +
                                                   bglb3 * fromIntegral j +
                                                   bglb5 * fromIntegral k in
                                      bglg `seq` case (bglg, (i, j, k)) of
                                                   nhd -> nhd `seq` nhd : bndj
                        in ncj `seq` nbndj `seq` loopj nj ncj nbndj
                  in loopj 0 ck bndk
            in loopk 0 0 []
  (m,nb)  = ( fromIntegral $ c - n, length b )         -- m 0-based from top, |band|
--  (s,res) = (b, s!!m)
  (s,res) = ( sortBy (flip compare `on` fst) b, s!!m ) -- sorted decreasing, result<

main = putStrLn $ show $ nthHam 1000000000000
