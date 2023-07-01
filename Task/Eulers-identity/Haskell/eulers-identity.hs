import Data.Complex

eulerIdentityZeroIsh :: Complex Double
eulerIdentityZeroIsh =
  exp (0 :+ pi) + 1

main :: IO ()
main = print eulerIdentityZeroIsh
