import Data.Bits

ulams5 :: [Int]
ulams5 = 1 : 2 : go 3 im0 jm0 km0
  where
    im0 = bit 1 .|. bit 2
    jm0 = bit 0
    km0 = 0
    go :: Int -- candidate
       -> Integer -- bitset of found Ulam numbers (0-origin)
       -> Integer -- candidates of Ulam numbers (u-origin)
       -> Integer -- disqualified candidates (u-origin)
       -> [Int]
    go u im jm km
      | isUlam    = u : go (succ u) im1 (jm1 .>>. 1) (km1 .>>. 1)
      | otherwise =     go (succ u) im  (jm  .>>. 1) (km  .>>. 1)
      where
        isUlam = testBit jm 0 && not (testBit km 0)
        im1 = setBit im u
        jm1 = jm .|. im
        km1 = km .|. (im .&. jm)

main = mapM_ (print . (ulams5 !!) . pred) [10,100,1000,10000,100000]
