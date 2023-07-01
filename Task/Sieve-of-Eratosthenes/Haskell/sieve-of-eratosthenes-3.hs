primesTo :: Int -> [Int] -- generate a list of primes to given limit...
primesTo limit
  | limit < 2 = []
  | otherwise = runST $ do
      let lmt = (limit - 3) `div` 2 - 1 -- limit index!
      oddcmpsts <- newArray (0, lmt) False -- when indexed is true is composite
      oddcmpstsf <- unsafeFreezeSTUArray oddcmpsts -- frozen in place!
      let getbpndx i = (i + i + 3, (i + i) * (i + 3) + 3) -- index -> bp, si0
          cullcmpst i = unsafeWrite oddcmpsts i True -- cull composite by index
          cull4bpndx (bp, si0) = mapM_ cullcmpst [ si0, si0 + bp .. lmt ]
      mapM_ cull4bpndx
            $ takeWhile ((>=) lmt . snd) -- for bp's <= square root limit
                        [ getbpndx i | (i, False) <- assocs oddcmpstsf ]
      return $ 2 : [ i + i + 3 | (i, False) <- assocs oddcmpstsf ]
