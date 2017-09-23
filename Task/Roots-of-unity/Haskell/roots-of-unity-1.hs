import Data.Complex (Complex, cis)

rootsOfUnity :: (Enum a, Floating a) => a -> [Complex a]
rootsOfUnity n =
  [ cis (2 * pi * k / n)
  | k <- [0 .. n - 1] ]

main :: IO ()
main = mapM_ print $ rootsOfUnity 3
