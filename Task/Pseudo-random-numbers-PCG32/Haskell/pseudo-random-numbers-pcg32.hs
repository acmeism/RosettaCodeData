import Data.Bits
import Data.Word
import System.Random
import Data.List

data PCGen = PCGen !Word64 !Word64

mkPCGen state sequence =
  let
    n = 6364136223846793005 :: Word64
    inc = (sequence `shiftL` 1) .|. 1 :: Word64
  in PCGen ((inc + state)*n + inc) inc

instance RandomGen PCGen where
   next (PCGen state inc) =
     let
       n = 6364136223846793005 :: Word64
       xs = fromIntegral $ ((state `shiftR` 18) `xor` state) `shiftR` 27 :: Word32
       rot = fromIntegral $ state `shiftR` 59 :: Int
     in (fromIntegral $ (xs `shiftR` rot) .|. (xs `shiftL` ((-rot) .&. 31))
        , PCGen (state * n + inc) inc)

   split _ = error "PCG32 is not splittable"

randoms' :: RandomGen g => g -> [Int]
randoms' g = unfoldr (pure . next) g

toFloat n = fromIntegral n / (2^32 - 1)
