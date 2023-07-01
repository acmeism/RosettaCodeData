countPrimes :: Word64 -> Int64
countPrimes n =
  if n < 3 then (if n < 2 then 0 else 1) else
  let
    {-# INLINE divide #-}
    divide :: Word64 -> Word64 -> Int
    divide nm d = truncate $ (fromIntegral nm :: Double) / fromIntegral d
    {-# INLINE half #-}
    half :: Int -> Int
    half x = (x - 1) `shiftR` 1
    rtlmt = floor $ sqrt (fromIntegral n :: Double)
    mxndx = (rtlmt - 1) `div` 2
    (!nbps, !nrs, !smalls, !roughs, !larges) = runST $ do
      mss <- unsafeNewArray_ (0, mxndx) :: ST s (STUArray s Int Word32)
      let msscst =
            castSTUArray :: STUArray s Int Word32 -> ST s (STUArray s Int Int64)
      mdss <- msscst mss -- for use in adjing counts LUT
      forM_ [ 0 .. mxndx ] $ \ i -> unsafeWrite mss i (fromIntegral i)
      mrs <- unsafeNewArray_ (0, mxndx) :: ST s (STUArray s Int Word32)
      forM_ [ 0 .. mxndx ] $ \ i -> unsafeWrite mrs i (fromIntegral i * 2 + 1)
      mls <- unsafeNewArray_ (0, mxndx) :: ST s (STUArray s Int Int64)
      forM_ [ 0 .. mxndx ] $ \ i ->
        let d = fromIntegral (i + i + 1)
        in unsafeWrite mls i (fromIntegral (divide n d - 1) `div` 2)
      cmpsts <- unsafeNewArray_ (0, mxndx) :: ST s (STUArray s Int Bool)

      let loop i !cbpi !rlmti =
            let sqri = (i + i) * (i + 1) in
            if sqri > mxndx then do
              fss <- unsafeFreezeSTUArray mss
              frs <- unsafeFreezeSTUArray mrs
              fls <- unsafeFreezeSTUArray mls
              return (cbpi, rlmti + 1, fss, frs, fls)
            else do
              v <- unsafeRead cmpsts i
              if v then loop (i + 1) cbpi rlmti else do
                unsafeWrite cmpsts i True -- cull current bp so not a "k-rough"!
                let bp = i + i + 1
                    -- partial cull by current base prime, bp...
                    cull c = if c > mxndx then return () else do
                               unsafeWrite cmpsts c True; cull (c + bp)

                    -- adjust `larges` according to partial sieve...
                    part ri nri = -- old "rough" index to new one...
                      if ri > rlmti then return (nri - 1) else do
                        r <- unsafeRead mrs ri -- "rough" always odd!
                        t <- unsafeRead cmpsts (fromIntegral r `shiftR` 1)
                        if t then part (ri + 1) nri else do -- skip newly culled
                          olv <- unsafeRead mls ri
                          let m = fromIntegral r * fromIntegral bp
                          adjv <- if m <= fromIntegral rtlmt then do
                                    let ndx = fromIntegral m `shiftR` 1
                                    sv <- unsafeRead mss ndx
                                    unsafeRead mls (fromIntegral sv - cbpi)
                                  else do
                                    sv <- unsafeRead mss (half (divide n m))
                                    return (fromIntegral sv)
                          unsafeWrite mls nri (olv - (adjv - fromIntegral cbpi))
                          unsafeWrite mrs nri r; part (ri + 1) (nri + 1)
                    !pm0 = ((rtlmt `div` bp) - 1) .|. 1 -- max base prime mult

                    adjc lmti pm = -- adjust smalls according to partial sieve:
                      if pm < bp then return () else do
                        c <- unsafeRead mss (pm `shiftR` 1)
                        let ac = c - fromIntegral cbpi -- correction
                            bi = (pm * bp) `shiftR` 1 -- start array index
                            adj si = if si > lmti then adjc (bi - 1) (pm - 2)
                                     else do ov <- unsafeRead mss si
                                             unsafeWrite mss si (ov - ac)
                                             adj (si + 1)
                        adj bi
                    dadjc lmti pm =
                      if pm < bp then return () else do
                        c <- unsafeRead mss (pm `shiftR` 1)
                        let ac = c - fromIntegral cbpi -- correction
                            bi = (pm * bp) `shiftR` 1 -- start array index
                            ac64 = fromIntegral ac :: Int64
                            dac = (ac64 `shiftL` 32) .|. ac64
                            dbi = (bi + 1) `shiftR` 1
                            dlmti = (lmti - 1) `shiftR` 1
                            dadj dsi = if dsi > dlmti then return ()
                                      else do dov <- unsafeRead mdss dsi
                                              unsafeWrite mdss dsi (dov - dac)
                                              dadj (dsi + 1)
                        when (bi .&. 1 /= 0) $ do
                          ov <- unsafeRead mss bi
                          unsafeWrite mss bi (ov - ac)
                        dadj dbi
                        when (lmti .&. 1 == 0) $ do
                          ov <- unsafeRead mss lmti
                          unsafeWrite mss lmti (ov - ac)
                        adjc (bi - 1) (pm - 2)
                cull sqri; nrlmti <- part 0 0
                dadjc mxndx pm0
                loop (i + 1) (cbpi + 1) nrlmti
      loop 1 0 mxndx

    !ans0 = unsafeAt larges 0 - -- combine all counts; each includes nbps...
              sum [ unsafeAt larges i | i <- [ 1 .. nrs - 1 ] ]
    -- adjust for all the base prime counts subracted above...
    !adj = (nrs + 2 * (nbps - 1)) * (nrs - 1) `div` 2
    !adjans0 = ans0 + fromIntegral adj

    loopr ri !acc = -- o final phi calculation for pairs of larger primes...
      let r = fromIntegral (unsafeAt roughs ri)
          q = n `div` r
          lmtsi = half (fromIntegral (q `div` r))
          lmti = fromIntegral (unsafeAt smalls lmtsi) - nbps
          addcnt pi !ac =
            if pi > lmti then ac else
            let p = fromIntegral (unsafeAt roughs pi)
                ci = half (fromIntegral (divide q p))
            in addcnt (pi + 1) (ac + fromIntegral (unsafeAt smalls ci))
      in if lmti <= ri then acc else -- break when up to cube root of range!
         -- adjust for the `nbps`'s over added in the `smalls` counts...
         let !adj = fromIntegral ((lmti - ri) * (nbps + ri - 1))
         in loopr (ri + 1) (addcnt (ri + 1) acc - adj)
  in loopr 1 adjans0 + 1 -- add one for only even prime of two!
