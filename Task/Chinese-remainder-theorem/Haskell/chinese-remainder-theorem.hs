module CRT ( chineseRemainder ) where

egcd :: Integral a => a -> a -> (a, a)
egcd _ 0 = (1, 0)
egcd a b = (t, s - q * t)
  where
    (s, t) = egcd b r
    (q, r) = a `quotRem` b

modInv :: Integral a => a -> a -> Maybe a
modInv a b = case egcd a b of
  (x, y) | a * x + b * y == 1 -> Just x
         | otherwise          -> Nothing

chineseRemainder :: Integral a => [a] -> [a] -> Maybe a
chineseRemainder residues modulii = do
  inverses <- sequence $ zipWith modInv crtModulii modulii
  return . (`mod` modPI) . sum $
    zipWith (*) crtModulii (zipWith (*) residues inverses)
  where
    modPI = product modulii
    crtModulii = map (modPI `div`) modulii
