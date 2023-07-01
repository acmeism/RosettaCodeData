import Control.Arrow
import Data.List (mapAccumR)

bor, band :: Int -> Int -> Int
bor = max
band = min
bnot :: Int -> Int
bnot = (1-)
