isIntegerF :: (Eq x, RealFrac x) => x -> Bool
isIntegerF x = x == fromInteger (truncate x)

instance ContainsInteger Double where isInteger = isIntegerF
instance Integral i => ContainsInteger (DecimalRaw i) where isInteger = isIntegerF
instance Integral i => ContainsInteger (Ratio i) where isInteger = isIntegerF
