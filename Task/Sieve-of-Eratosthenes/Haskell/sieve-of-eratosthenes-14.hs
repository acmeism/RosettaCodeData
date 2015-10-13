import Data.Bits
import Data.Array.Base
import Control.Monad.ST
import Data.Array.ST (runSTUArray, STUArray(..))

type PrimeType = Int
szPGBTS = (2^14) * 8 :: PrimeType -- CPU L1 cache in bits

primesPaged :: () -> [PrimeType]
primesPaged() = 2 : _Y (listPagePrms . pagesFrom 0) where
  _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator
  listPagePrms (hdpg @ (UArray lowi _ rng _) : tlpgs) =
    let loop i = if i >= rng then listPagePrms tlpgs
                 else if unsafeAt hdpg i then loop (i + 1)
                      else let ii = lowi + fromIntegral i in
                           case 3 + ii + ii of
                             p -> p `seq` p : loop (i + 1) in loop 0
  makePg lowi bps = runSTUArray $ do
    let limi = lowi + szPGBTS - 1
    let nxt = 3 + limi + limi -- last candidate in range
    cmpsts <- newArray (lowi, limi) False
    let pbts = fromIntegral szPGBTS
    let cull (p:ps) =
          let sqr = p * p in
          if sqr > nxt then return cmpsts
          else let pi = fromIntegral p in
               let cullp c = if c > pbts then return ()
                             else do
                               unsafeWrite cmpsts c True
                               cullp (c + pi) in
               let a = (sqr - 3) `shiftR` 1 in
               let s = if a >= lowi then fromIntegral (a - lowi)
                       else let r = fromIntegral ((lowi - a) `rem` p) in
                            if r == 0 then 0 else pi - r in
               do { cullp s; cull ps}
    if lowi == 0 then do
      pg0 <- unsafeFreezeSTUArray cmpsts
      cull $ listPagePrms [pg0]
    else cull bps
  pagesFrom lowi bps =
    let cf lwi = case makePg lwi bps of
          pg -> pg `seq` pg : cf (lwi + szPGBTS) in cf lowi
