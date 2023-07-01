#!/usr/bin/runhaskell

import Control.Monad
import System.IO

pi_ = g(1,0,1,1,3,3) where
  g (q,r,t,k,n,l) =
   if 4*q+r-t < n*t
    then n : g (10*q, 10*(r-n*t), t, k, div (10*(3*q+r)) t - 10*n, l)
    else g (q*k, (2*q+r)*l, t*l, k+1, div (q*(7*k+2)+r*l) (t*l), l+2)

digs = insertPoint digs'
  where insertPoint (x:xs) = x:'.':xs
        digs' = map (head . show) pi_

main = do
  hSetBuffering stdout $ BlockBuffering $ Just 80
  forM_ digs putChar
