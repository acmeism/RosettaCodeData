x ~~ eps = abs x <= eps

almostInteger :: RealFrac a => a -> a -> Bool
almostInteger eps x = (x - fromInteger (round x)) ~~ eps

almostIntegerC :: RealFrac a => a -> Complex a -> Bool
almostIntegerC eps z = almostInteger eps (realPart z) && (imagPart z) ~~ eps
