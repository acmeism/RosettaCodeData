-- for given a, b and x returns a point on the positive branch of elliptic curve (if point exists)
elliptic a b Nothing  = Just Zero
elliptic a b (Just x) =
  do let y2 = x**3 + a*x + b
     guard (y2 > 0)
     return $ Elliptic x (sqrt y2)

addition a b x1 x2 =
  let p = elliptic a b
      s = p x1 <> p x2
  in (s /= Nothing) ==> (s <> (inv <$> s) == Just Zero)

associativity a b x1 x2 x3 =
  let p = elliptic a b
  in (p x1 <> p x2) <> p x3 == p x1 <> (p x2 <> p x3)

commutativity a b x1 x2 =
  let p = elliptic a b
  in p x1 <> p x2 == p x2 <> p x1
