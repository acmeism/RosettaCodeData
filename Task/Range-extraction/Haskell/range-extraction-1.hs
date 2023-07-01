import Data.List (intercalate)

extractRange :: [Int] -> String
extractRange = intercalate "," . f
  where f :: [Int] -> [String]
        f (x1 : x2 : x3 : xs) | x1 + 1 == x2 && x2 + 1 == x3
             = (show x1 ++ '-' : show xn) : f xs'
          where (xn, xs') = g (x3 + 1) xs
                g a (n : ns) | a == n    = g (a + 1) ns
                             | otherwise = (a - 1, n : ns)
                g a []                   = (a - 1, [])
        f (x : xs)            = show x : f xs
        f []                  = []
