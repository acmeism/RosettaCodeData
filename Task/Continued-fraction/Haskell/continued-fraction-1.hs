import Data.List (unfoldr)
import Data.Char (intToDigit)

-- continued fraction represented as a (possibly infinite) list of pairs
sqrt2, napier, myPi :: [(Integer, Integer)]
sqrt2 = zip (1 : [2,2 ..]) [1,1 ..]

napier = zip (2 : [1 ..]) (1 : [1 ..])

myPi = zip (3 : [6,6 ..]) ((^ 2) <$> [1,3 ..])

-- approximate a continued fraction after certain number of iterations
approxCF
  :: (Integral a, Fractional b)
  => Int -> [(a, a)] -> b
approxCF t = foldr (\(a, b) z -> fromIntegral a + fromIntegral b / z) 1 . take t

-- infinite decimal representation of a real number
decString
  :: RealFrac a
  => a -> String
decString frac = show i ++ '.' : decString_ f
  where
    (i, f) = properFraction frac
    decString_ = map intToDigit . unfoldr (Just . properFraction . (10 *))

main :: IO ()
main =
  mapM_
    (putStrLn .
     take 200 . decString . (approxCF 950 :: [(Integer, Integer)] -> Rational))
    [sqrt2, napier, myPi]
