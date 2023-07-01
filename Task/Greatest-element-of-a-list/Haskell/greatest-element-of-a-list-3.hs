import Data.List (maximumBy)
import Data.Ord (comparing)

wds :: [String]
wds = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta"]

main :: IO ()
main = print $ maximumBy (comparing length) wds
