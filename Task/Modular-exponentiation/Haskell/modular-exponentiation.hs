-- Private type. Do not use outside of the modPow function
newtype ModN = ModN (Integer, Integer) deriving (Eq, Show)
instance Num ModN where
  -- actually only multiplication needs to be implemented
  -- but we do some of the other ones too for good measure
  ModN (x, m) + ModN (y, m') | m == m' = ModN ((x + y) `mod` m, m)
                             | otherwise = undefined
  ModN (x, m) * ModN (y, m') | m == m' = ModN ((x * y) `mod` m, m)
                             | otherwise = undefined
  negate (ModN (x, m)) = ModN ((- x) `mod` m, m)
  abs _ = undefined
  signum _ = undefined
  fromInteger _ = undefined

modPow :: Integer -> Integer -> Integer -> Integer
modPow _ 0 m = 1 `mod` m
modPow a b m = c
  where a' = ModN (a, m)
        ModN (c, _) = a' ^ b

main :: IO ()
main = print $ modPow a b m
  where a = 2988348162058574136915891421498819466320163312926952423791023078876139
        b = 2351399303373464486466122544523690094744975233415544072992656881240319
        m = 10 ^ 40
