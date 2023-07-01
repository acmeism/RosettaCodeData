tests = all (== True)
  [ isInteger (5          :: Integer)
  , isInteger (5.0        :: Decimal)
  , isInteger (-5         :: Integer)
  , isInteger (0          :: Decimal)
  , isInteger (-2.1e120   :: Double)
  , isInteger (5 % 1      :: Rational)
  , isInteger (4 % 2      :: Rational)
  , isInteger (5 :+ 0     :: Complex Integer)
  , isInteger (5.0 :+ 0.0 :: Complex Decimal)
  , isInteger (6 % 3 :+ 0 :: Complex Rational)
  , isInteger (1/0        :: Double) -- Infinity is integer
  , isInteger (1.1/0      :: Double) -- Infinity is integer
  , not $ isInteger (5.01       :: Decimal)
  , not $ isInteger (-5e-2      :: Double)
  , not $ isInteger (5 % 3      :: Rational)
  , not $ isInteger (5 :+ 1     :: Complex Integer)
  , not $ isInteger (6 % 4 :+ 0 :: Complex Rational)
  , not $ isInteger (5.0 :+ 1.0 :: Complex Decimal)
  , almostInteger 0.01 2.001
  , almostInteger 0.01 (-1.999999)
  , almostInteger (1 % 10) (24 % 23)
  , not $ almostInteger 0.01 2.02
  , almostIntegerC 0.001 (5.999999 :+ 0.000001)
  ]
