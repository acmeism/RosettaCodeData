maxRealFloat :: RealFloat a => a -> a
maxRealFloat x = encodeFloat b (e-1) `asTypeOf` x where
  b     = floatRadix x - 1
  (_,e) = floatRange x

infinity :: RealFloat a => a
infinity = if isInfinite inf then inf else maxRealFloat 1.0 where
  inf = 1/0
