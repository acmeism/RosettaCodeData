import qualified Data.Set as S

setA :: S.Set String
setA = S.fromList ["alpha", "beta", "gamma", "delta", "epsilon"]

setB :: S.Set String
setB = S.fromList ["delta", "epsilon", "zeta", "eta", "theta"]

main :: IO ()
main = (print . S.toList) (S.intersection setA setB)
