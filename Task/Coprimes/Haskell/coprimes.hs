------------------------- COPRIMES -----------------------

coprime :: Integral a => a -> a -> Bool
coprime a b = 1 == gcd a b


--------------------------- TEST -------------------------
main :: IO ()
main =
  print $
    filter
      ((1 ==) . uncurry gcd)
      [ (21, 15),
        (17, 23),
        (36, 12),
        (18, 29),
        (60, 15)
      ]
