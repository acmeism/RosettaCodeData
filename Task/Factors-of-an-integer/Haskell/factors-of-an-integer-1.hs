import HFM.Primes (primePowerFactors)
import Control.Monad (mapM)
import Data.List (product)

-- primePowerFactors :: Integer -> [(Integer,Int)]

factors = map product .
          mapM (\(p,m)-> [p^i | i<-[0..m]]) . primePowerFactors
