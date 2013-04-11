import Control.Arrow

bor, band :: Int -> Int -> Int
bor = max
band = min
bnot :: Int -> Int
bnot = (1-)
