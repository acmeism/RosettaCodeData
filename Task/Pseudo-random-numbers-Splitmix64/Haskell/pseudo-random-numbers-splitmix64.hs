import Data.Bits

import Data.Word
import Data.List

next :: Word64 -> (Word64, Word64)
next state = f4 $ state + 0x9e3779b97f4a7c15
  where
    f1 z = (z `xor` (z `shiftR` 30)) * 0xbf58476d1ce4e5b9
    f2 z = (z `xor` (z `shiftR` 27)) * 0x94d049bb133111eb
    f3 z = z `xor` (z `shiftR` 31)
    f4 s = ((f3 . f2 . f1) s, s)

randoms = unfoldr (pure . next)

toFloat n = fromIntegral n / (2^64 - 1)
