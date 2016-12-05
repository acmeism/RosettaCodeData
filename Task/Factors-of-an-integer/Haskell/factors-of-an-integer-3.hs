import Data.List (group)
primePowerFactors = map (\x-> (head x, length x)) . group . factorize
