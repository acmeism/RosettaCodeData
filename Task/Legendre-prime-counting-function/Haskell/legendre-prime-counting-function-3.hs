cTinyPhiPrimes :: [Int]
cTinyPhiPrimes = [ 2, 3, 5, 7, 11, 13 ]
cC :: Int
cC = length cTinyPhiPrimes - 1
cTinyPhiOddCirc :: Int
cTinyPhiOddCirc = product cTinyPhiPrimes `div` 2
cTinyPhiTot :: Int
cTinyPhiTot = product [ p - 1 | p <- cTinyPhiPrimes ]
cTinyPhiLUT :: UArray Int Word32
cTinyPhiLUT = runSTUArray $ do
  ma <- newArray (0, cTinyPhiOddCirc - 1) 1
  forM_ (drop 1 cTinyPhiPrimes) $ \ bp -> do
    let i = (bp - 1) `shiftR` 1
    let sqri = (i + i) * (i + 1)
    unsafeWrite ma i 0
    forM_ [ sqri, sqri + bp .. cTinyPhiOddCirc - 1 ] $ \ c -> unsafeWrite ma c 0
  let tot i acc =
        if i >= cTinyPhiOddCirc then return ma else do
          v <- unsafeRead ma i
          if v == 0 then do unsafeWrite ma i acc; tot (i + 1) acc
          else do let nacc = acc + 1
                  unsafeWrite ma i nacc; tot (i + 1) nacc
  tot 0 0
tinyPhi :: Word64 -> Int64
tinyPhi n =
  let on = (n - 1) `shiftR` 1
      numcyc = on `div` fromIntegral cTinyPhiOddCirc
      rem = fromIntegral $ on - numcyc * fromIntegral cTinyPhiOddCirc
  in fromIntegral numcyc * fromIntegral cTinyPhiTot +
       fromIntegral (unsafeAt cTinyPhiLUT rem)

countPrimes :: Word64 -> Int64
countPrimes n =
  if n < 3 then (if n < 2 then 0 else 1) else
  let sqrtn = truncate $ sqrt $ fromIntegral n
      qdrtn = truncate $ sqrt $ fromIntegral sqrtn
      rtlmt = (sqrtn - 3) `div` 2
      qrtlmt = (qdrtn - 3) `div` 2
      oddPrimes@(UArray _ _ psz _) = runST $ do -- UArray of odd primes...
        cmpsts <- newArray (0, rtlmt) False :: ST s (STUArray s Int Bool)
        forM_ [ 0 .. qrtlmt ] $ \ i -> do
          t <- unsafeRead cmpsts i
          unless t $ do
            let sqri = (i + i) * (i + 3) + 3
                bp = i + i + 3
            forM_ [ sqri, sqri + bp .. rtlmt ] $ \ c ->
              unsafeWrite cmpsts c True
        fcmpsts <- unsafeFreezeSTUArray cmpsts
        let !numoprms = sum $ [ 1 | False <- elems fcmpsts ]
            prms = [ fromIntegral $ i + i + 3 | (i, False) <- assocs fcmpsts ]
        return $ listArray (0, numoprms - 1) prms :: ST s (UArray Int Word32)
      lvl pi pilmt !m !acc =
        if pi >= pilmt then acc else
        let p = fromIntegral $ unsafeAt oddPrimes pi
            nm = m * p in
        if n <= nm * p then acc + fromIntegral (pilmt - pi) else
        let !q = fromIntegral $ n `div` nm
            !nacc = acc + tinyPhi q
            !sacc = if pi <= cC then 0 else lvl cC pi nm 0
        in lvl (pi + 1) pilmt m $ nacc - sacc

  in  tinyPhi n - lvl cC psz 1 0 + fromIntegral psz
