-- directly find n-th Hamming number, in ~ O(n^{2/3}) time
-- based on "top band" idea by Louis Klauder, from DDJ discussion
-- by Will Ness, original post: drdobbs.com/blogs/architecture-and-design/228700538

import Data.List
import Data.Function

main = let (r,t) = nthHam 1000000 in print t >> print (trival t)

lb3 = logBase 2 3;  lb5 = logBase 2 5;  lb30_2 = logBase 2 30 / 2
trival (i,j,k)    = 2^i * 3^j * 5^k
estval n
    | n > 500000  = (v - lb30_2 + (3/v), 6/v)             -- the space tweak! (thx, GBG!)
    | n > 500000  = (v - 2.4496 , 0.0076 )                -- empirical estimation
    | n > 50000   = (v - 2.4424 , 0.0146 )                --   correction, base 2
    | n > 500     = (v - 2.3948 , 0.0723 )                --     (dist,width)
    | n > 1       = (v - 2.2506 , 0.2887 )                -- around (log $ sqrt 30),
    | otherwise   = (v - 2.2506 , 0.5771 )                --   says WP
  where v = (6*lb3*lb5* fromIntegral n)**(1/3)            -- estimated logval, base 2

nthHam :: Integer -> (Double, (Int, Int, Int))            -- ( 64bit: use Int!!!     NB! )
nthHam n                                                  -- n: 1-based: 1,2,3...
  | n <= 0    = error $ "n is 1--based: must be n > 0: " ++ show n
  | w >= 1    = error $ "Breach of contract: (w < 1):  " ++ show w
  | m <  0    = error $ "Not enough triples generated: " ++ show (c,n)
  | m >= nb   = error $ "Generated band is too narrow: " ++ show (m,nb)
  | otherwise = sortBy (flip compare `on` fst) b !! m     -- m-th from top in sorted band
 where
  (hi,w) = estval n                                       --   hi > logval > hi-w
  m      = fromIntegral (c - n)                           -- target index, from top
  nb     = length b                                       -- length of the band
  (c,b)  = foldl_ (\(c,b) (i,t)-> let c2=c+i in c2`seq`   -- ( total count, the band )
                     case t of []-> (c2,b);[v]->(c2,v:b) ) (0,[])  -- ( =~= mconcat )
            [ ( fromIntegral i+1,                         -- total triples w/ this (j,k)
                [ (r,(i,j,k)) | frac < w ] )              -- store it, if inside band
              | k <- [ 0 .. floor ( hi   /lb5) ],  let p = fromIntegral k*lb5,
                j <- [ 0 .. floor ((hi-p)/lb3) ],  let q = fromIntegral j*lb3 + p,
                let (i,frac) = pr  (hi-q) ;            r = hi - frac  -- r = i + q
            ] where  pr      = properFraction             -- pr 1.24 => (1,0.24)
                     foldl_  = foldl'
