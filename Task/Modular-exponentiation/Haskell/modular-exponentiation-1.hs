modPow :: Integer -> Integer -> Integer -> Integer -> Integer
modPow b e 1 r = 0
modPow b 0 m r = r
modPow b e m r
  | e `mod` 2 == 1 = modPow b' e' m (r * b `mod` m)
  | otherwise = modPow b' e' m r
  where
    b' = b * b `mod` m
    e' = e `div` 2

main = do
  print (modPow 2988348162058574136915891421498819466320163312926952423791023078876139
    2351399303373464486466122544523690094744975233415544072992656881240319
    (10 ^ 40)
    1)
