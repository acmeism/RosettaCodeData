import Data.Bits
import Data.Word
import System.Random
import Data.List

newtype XorShift = XorShift Word64

instance RandomGen XorShift where
   next (XorShift state) = (out newState, XorShift newState)
     where
       newState = (\z -> z `xor` (z `shiftR` 27)) .
                  (\z -> z `xor` (z `shiftL` 25)) .
                  (\z -> z `xor` (z `shiftR` 12)) $ state
       out x = fromIntegral $ (x * 0x2545f4914f6cdd1d) `shiftR` 32

   split _ = error "XorShift is not splittable"

randoms' :: RandomGen g => g -> [Int]
randoms' = unfoldr (pure . next)

toFloat n = fromIntegral n / (2^32 - 1)
