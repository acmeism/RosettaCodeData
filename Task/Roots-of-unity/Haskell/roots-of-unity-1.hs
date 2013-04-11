import Data.Complex

rootsOfUnity n = [cis (2*pi*k/n) | k <- [0..n-1]]
