import HFM.Primes(primePowerFactors)
import Data.List

factors = map product.
          mapM (uncurry((. enumFromTo 0) . map .(^) )) . primePowerFactors
